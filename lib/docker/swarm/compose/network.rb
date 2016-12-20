require "docker/swarm/compose/resource"

module Docker
  module Swarm
    module Compose
      class Network < Resource
        attr_accessor :driver, :driver_opts, :enable_ipv6, :ipam, :internal,
                      :labels, :external
      end
    end
  end
end