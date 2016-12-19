require "docker/api/entity"

module Docker
  module Api
    class Container < Entity
      def inspect_container(include_size = false)
        client.container_inspect(id, {size: !!include_size}, self)
      end
    end
  end
end