require "docker/api/entity"

module Docker
  module Api
    class ContainerUpdateResponse < Entity
      attr_accessor :warnings
    end
  end
end