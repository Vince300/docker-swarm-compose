require "json"
require "uri"
require "docker/uri/unix"
require "rest-client"
require "docker/restclient/request"

require "docker/api/resources/containers"

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

      include Resources::Containers

      private
      def get(url, params)
        JSON.load(get_raw(url, params))
      end

      def get_raw(url, params)
        RestClient.get(host.to_s + url, {params: params})
      end

      def post_json(url, params, payload)
        JSON.load(post_json_raw(url, params, payload))
      end

      def post_json_raw(url, params, payload)
        RestClient.post(host.to_s + url, payload.to_json, {params: params, content_type: :json})
      end
    end
  end
end