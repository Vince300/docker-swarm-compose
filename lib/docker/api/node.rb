require "docker/api/entity"

module Docker
  module Api
    class Node < Entity
      def inspect_node
        client.node_inspect(id, self)
      end

      def remove(params = {})
        client.node_remove(id, params)
      end

      def update(config, params = {})
        client.node_update(config, params)
      end
    end
  end
end