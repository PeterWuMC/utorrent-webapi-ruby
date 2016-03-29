module UTorrent
  class Configuration
    attr_accessor :url, :username, :password, :port
    attr_writer :protocol

    def protocol
      @protocol ||= 'http'
    end
  end
end
