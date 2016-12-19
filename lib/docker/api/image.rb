require "docker/api/entity"

module Docker
  module Api
    class Image < Entity
      def inspect_image
        client.image_inspect(id, {}, self)
      end
    end
  end
end