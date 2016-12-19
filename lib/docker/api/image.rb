require "docker/api/entity"

module Docker
  module Api
    class Image < Entity
      def inspect_image
        client.image_inspect(id, {}, self)
      end

      def history
        client.image_history(name)
      end

      def push(params = {}, &block)
        client.image_push(name, params, block)
      end

      def tag(params = {})
        client.image_tag(name, params)
      end

      def remove(params = {})
        client.image_remove(name, params)
      end
    end
  end
end