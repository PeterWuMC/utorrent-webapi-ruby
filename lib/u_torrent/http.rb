module UTorrent
  module Http
    module_function

    def get_with_authentication(query={})
      query.merge!(token: token)
      get(UTorrent.base_uri, query) do |request|
        request['Cookie'] = cookie
      end
    end

    def get(uri, query={})
      uri.query = urify_query(query)
      request = Net::HTTP::Get.new(uri)
      request.basic_auth(
        UTorrent.configuration.username,
        UTorrent.configuration.password
      )

      yield request if block_given?

      UTorrent.log.debug "HTTP::Get #{request.path}"

      http = Net::HTTP.new(uri.host, uri.port)
      http.request(request)
    end

    def token
      @token ||= begin
        generate!
        @token
      end
    end

    def cookie
      @cookie ||= begin
        generate!
        @cookie
      end
    end

    def generate!
      uri = UTorrent.base_uri
      uri.path = '/gui/token.html'

      response = get(uri)

      @token = Nokogiri::HTML(response.body).at_xpath('//div').content
      @cookie = response['set-cookie']
    end

    def urify_query(query_hash)
      URI.encode_www_form(query_hash.to_a)
    end

  end
end
