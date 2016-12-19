require "docker/api/entity"

module Docker
  module Api
    class ContainerCreateResponse < Entity
      def container(include_size = false)
        client.container(id, {size: !!include_size})
      end
    end
  end
end