require "docker/api/entity"
require "docker/api/volume"

module Docker
  module Api
    class VolumeListResponse < Entity
      attr_reader :volumes

      def volumes=(value)
        # Parse volume specifications as Volume entities
        if not value.nil? and value.length > 0
          if value[0].is_a? Hash
            value = value.collect { |v| Volume.parse(client, v) }
          end
        end

        @volumes = value || []
      end
    end
  end
end