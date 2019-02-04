require 'timeout'
require 'date'

module UTorrent
  class Torrent
    STATUSES = {
      'Started'           => 1,
      'Checking'          => 2,
      'Start after check' => 4,
      'Checked'           => 8,
      'Error'             => 16,
      'Paused'            => 32,
      'Queued'            => 64,
      'Loaded'            => 128,
    }

    ACTIONS = [
      :start, :stop, :force_start,
      :pause, :unpause, :recheck,
      :remove, :remove_data
    ]

    ATTRIBUTES = [
      :id, nil, :name, :size, nil, :downloaded, :uploaded, :ratio,
      :upload_speed, :download_speed, :eta, :label, :peers_connected,
      :peers_in_swarm, :seeds_connected, :seeds_in_swarm, :availability,
      :queue_order, :remaining, :url, nil, :status, nil, :added_epoch,
      :completed_epoch, nil, :current_directory, nil, nil, nil
    ]

    include UTorrent::Base

    def self.all
      response = UTorrent::Http.get_with_authentication(list: 1)
      torrents_array = JSON.parse(response.body)['torrents']
      torrents_array.map { |torrent| self.new(torrent) }
    end

    def self.find(id)
      all.detect { |torrent| torrent.id == id }
    end

    def self.add(url)
      UTorrent::Http.get_with_authentication(
        action: 'add-url',
        s:      url,
      )

      Timeout.timeout(5) do
        while(true) do
          all_torrents = UTorrent::Torrent.all
          matching_torrent = all_torrents.detect do |torrent|
            torrent.url == url
          end

          return matching_torrent unless matching_torrent.nil?
          sleep 0.1
        end
      end
    end

    def statuses
      status_code = @raw_array[1]
      status = STATUSES.select { |_, value| status_code & value == value }
      status.keys.reverse
    end

    def added
      DateTime.strptime(added_epoch.to_s, '%s')
    end

    def completed
      DateTime.strptime(completed_epoch.to_s, '%s')
    end

    def percentage
      @raw_array[4].to_f / 10
    end

    def label=(label)
      UTorrent::Http.get_with_authentication(
        action: 'setprops',
        hash:   id,
        s:      'label',
        v:      label
      )
      refresh!
    end

    def files
      response = UTorrent::Http.get_with_authentication(action: 'getfiles', hash: id)
      files_array = JSON.parse(response.body)['files'].last
      files_array.each_with_index.map { |file, i| UTorrent::File.new(file, i, id) }
    end

    ACTIONS.each do |action|
      define_method "#{action}!" do
        execute(action.to_s.delete('_'))
        true
      end
    end

    %w(finished downloading seeding).each do |status|
      define_method "#{status}?" do
        self.status == status.capitalize
      end
    end

    def refresh!
      torrent = self.class.find(id)
      @raw_array = torrent.raw_array
    end

    private

    def execute(action)
      UTorrent::Http.get_with_authentication(
        action: action,
        hash:    id
      )
      refresh!
    end
  end
end
