require "docker/api/entity"

module Docker
  module Api
    class Network < Entity
      def inspect_network
        client.network_inspect(id, self)
      end

      def connect(config)
        client.network_connect(id, config)
      end

      def disconnect(config)
        client.network_disconnect(id, config)
      end

      def remove
        client.network_remove(id)
      end
    end
  end
end