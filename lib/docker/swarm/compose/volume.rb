require "docker/swarm/compose/resource"

module Docker
  module Swarm
    module Compose
      class Volume < Resource
        attr_accessor :driver, :driver_opts, :external, :labels
      end
    end
  end
end