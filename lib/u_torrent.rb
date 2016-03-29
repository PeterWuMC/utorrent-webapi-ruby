require 'cgi'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'json'
require_relative 'u_torrent/configuration'
require_relative 'u_torrent/http'
require_relative 'u_torrent/base'
require_relative 'u_torrent/torrent'
require_relative 'u_torrent/file'


module UTorrent
  module_function

  def configuration=(configuration)
    @configuration = configuration
  end

  def configuration
    @configuration
  end

  def base_uri
    URI.parse("#{@configuration.protocol}://#{@configuration.url}:#{@configuration.port}/gui/")
  end
end
