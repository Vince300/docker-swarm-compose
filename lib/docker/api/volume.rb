require "docker/api/entity"

module Docker
  module Api
    class Volume < Entity
      attr_accessor :name, :driver, :mountpoint, :labels, :scope, :status

      def inspect_volume
        client.volume_inspect(self.name, self)
      end

      def remove
        client.volume_remove(self.name)
      end
    end
  end
end