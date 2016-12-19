require "docker/api/entity"

module Docker
  module Api
    class ServiceCreateResponse < Entity
      def service
        client.service_inspect(id)
      end
    end
  end
end