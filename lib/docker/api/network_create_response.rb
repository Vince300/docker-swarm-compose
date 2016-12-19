require "docker/api/entity"

module Docker
  module Api
    class NetworkCreateResponse < Entity
      def network
        client.network_inspect(id)
      end
    end
  end
end