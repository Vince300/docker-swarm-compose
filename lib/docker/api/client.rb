require "json"
require "uri"
require "docker/uri/unix"
require "rest-client"
require "docker/restclient/request"

require "docker/api/container"

module Docker
  module Api
    class Client
      attr_reader :host

      def initialize(host = '/var/run/docker.sock')
        if host =~ /^\//
          fail "invalid socket" if host =~ /\/$/
          @host = URI('unix://' + host)
        else
          @host = host.sub(/\/*$/, '')
        end
      end

      def container(name_or_id, params = {}, existing = nil)
        response = get("/containers/#{URI.encode(name_or_id)}/json", params)

        if existing
          existing.parse(response)
        else
          Container.parse(self, response)
        end
      end

      def containers(params = {})
        get('/containers/json', params).collect { |c| Container.parse(self, c) }
      end

      private
      def get(url, params)
        JSON.load(RestClient.get(host.to_s + url, {params: params}).body)
      end
    end
  end
end