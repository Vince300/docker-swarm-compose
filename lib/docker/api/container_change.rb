require "docker/api/entity"

module Docker
  module Api
    class ContainerChange < Entity
      def kind
        case @attributes['Kind']
        when 0
          :modify
        when 1
          :add
        when 2
          :delete
        default
          nil
        end
      end
    end
  end
end