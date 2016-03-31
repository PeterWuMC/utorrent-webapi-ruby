require 'logger'

module UTorrent
  class Configuration
    attr_accessor :url, :username, :password, :port
    attr_writer :protocol, :logger

    def protocol
      @protocol ||= 'http'
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
