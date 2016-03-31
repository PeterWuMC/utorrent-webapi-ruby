module UTorrent
  class File
    PRIORITIES = {
      0 => "Don't Download",
      1 => 'Low Priority',
      2 => 'Normal Priority',
      3 => 'High Priority',
    }

    ATTRIBUTES = [
      :name, :size, :downloaded, nil,
      nil, nil, nil, nil, nil, nil, nil, nil, nil
    ]

    include UTorrent::Base

    attr_reader :index, :torrent_id

    def self.find_by_torrent_id_and_index(torrent_id, index)
      UTorrent::Torrent.find(torrent_id).files[index]
    end

    def initialize(array, index, torrent_id)
      super(array)
      @index      = index
      @torrent_id = torrent_id
    end

    def priority_display_value
      PRIORITIES[priority]
    end

    def priority
      @raw_array[3]
    end

    def skip!
      send(:priority=, 0)
    end

    def skipped?
      priority == 0
    end

    def priority=(priority)
      UTorrent::Http.get_with_authentication(
        action: 'setprio',
        hash:    torrent_id,
        f:       index,
        p:       priority
      )
      refresh!
    end

    def refresh!
      file = self.class.find_by_torrent_id_and_index(torrent_id, index)
      @raw_array = file.raw_array
    end
  end
end
