require "rest-client"
require "net_http_unix"

require "docker/uri/unix"

module RestClient
  # Patch RestClient in order to handle requests to Unix domain sockets
  class Request
    alias_method :orig_net_http_object, :net_http_object

    def net_http_object(hostname, port)
      if uri.is_a? URI::UNIX
        NetX::HTTPUnix.new('unix://' + uri.socket_path)
      else
        orig_net_http_object(hostname, port)
      end
    end
  end
end