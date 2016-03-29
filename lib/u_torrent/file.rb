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

    def priority
      PRIORITIES[@raw_array[3]]
    end

  end
end
