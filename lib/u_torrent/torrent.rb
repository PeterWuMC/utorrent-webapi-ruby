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
      :queue_order, :remaining, nil, nil, :status, nil, nil, nil, nil,
      :current_directory, nil, nil, nil
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
        s:      url
      )
      UTorrent::Torrent.all.detect {|torrent| torrent.queue_order == UTorrent::Torrent.all.map(&:queue_order).max}
    end

    def statuses
      status_code = @raw_array[1]
      status = STATUSES.select { |_, value| status_code & value == value }
      status.keys.reverse
    end

    def percentage
      @raw_array[4].to_f / 10
    end

    def files
      response = UTorrent::Http.get_with_authentication(action: 'getfiles', hash: id)
      files_array = JSON.parse(response.body)['files'].last
      files_array.each_with_index.map { |file, i| UTorrent::File.new(file, i, id) }
    end

    ACTIONS.each do |action|
      define_method action do
        execute(action.to_s.delete('_'))
        true
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
