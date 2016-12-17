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
      def get(url, params = {})
        JSON.load(get_raw(url, params))
      end

      def get_raw(url, params = {})
        handle_errors do
          RestClient.get(resource_url(url), {params: params})
        end
      end

      def post_json(url, params = {}, payload = nil)
        JSON.load(post_json_raw(url, params, payload))
      end

      def post_json_raw(url, params = {}, payload = nil)
        handle_errors do
          RestClient.post(resource_url(url), payload.to_json, {params: params, content_type: :json})
        end
      end

      def post_raw(url, params = {})
        handle_errors do
          RestClient.post(resource_url(url), nil, {params: params})
        end
      end

      def handle_errors
        begin
          yield
        rescue RestClient::ExceptionWithResponse => e
          fail JSON.load(e.response)['message']
        end
      end

      def resource_url(path)
        host.to_s + path
      end
    end
  end
end