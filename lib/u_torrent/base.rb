module UTorrent
  module Base
    attr_reader :raw_array

    def initialize(array)
      @raw_array = array
    end

    def self.included(base)
      base.class_eval do
        base::ATTRIBUTES.each_with_index do |attr_name, i|
          unless attr_name.nil?
            define_method attr_name do
              @raw_array[i]
            end
          end
        end
      end
    end

  end
end
