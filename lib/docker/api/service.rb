require "docker/api/entity"

module Docker
  module Api
    class Service < Entity
      def inspect_service
        client.service_inspect(id, self)
      end

      def remove
        client.service_remove(id)
      end

      def update(config, params = {})
        client.service_update(id, config, params)
      end
    end
  end
end