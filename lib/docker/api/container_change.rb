require "docker/api/entity"

module Docker
  module Api
    class ContainerChange < Entity
      attr_accessor :path, :kind

      def kind
        case @kind
        when 0
          :modify
        when 1
          :add
        when 2
          :delete
        end
      end
    end
  end
end