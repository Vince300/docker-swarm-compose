require "docker/api/entity"

module Docker
  module Api
    class Volume < Entity
      def inspect_volume
        client.volume_inspect(name, self)
      end

      def remove
        client.volume_remove(name)
      end
    end
  end
end