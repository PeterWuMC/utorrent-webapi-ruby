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

    ATTRIBUTES = [
      :id, nil, :name, :size, nil, :downloaded, :uploaded, :ratio,
      :upload_speed, :download_speed, :eta, :label, :peers_connected,
      :peers_in_swarm, :seeds_connected, :seeds_in_swarm, :availability,
      :queue_order, :remaining, nil, nil, :status, nil, nil, nil, nil,
      :current_directory, nil, nil, nil
    ]

    def self.all
      uri = UTorrent.base_uri
      response = UTorrent::Http.get_with_authentication(uri, list: 1)
      torrents_array = JSON.parse(response.body)['torrents']
      torrents_array.map { |torrent| self.new(torrent) }
    end

    def self.find(id)
      all.detect { |torrent| torrent.id == id }
    end

    attr_reader :raw_array

    def initialize(array)
      @raw_array = array
    end

    ATTRIBUTES.each_with_index do |attr_name, i|
      unless attr_name.nil?
        define_method attr_name do
          @raw_array[i]
        end
      end
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
      uri = UTorrent.base_uri
      response = UTorrent::Http.get_with_authentication(uri, action: 'getfiles', hash: id)
      files_array = JSON.parse(response.body)['files'].last
      files_array.map { |file| UTorrent::File.new(file) }
    end

  end
end
