require "yaml"

require "docker/swarm/compose/service"
require "docker/swarm/compose/volume"
require "docker/swarm/compose/network"

module Docker
  module Swarm
    module Compose
      class Config
        def initialize(services, volumes, networks)
          @services = services
          @volumes = volumes
          @networks = networks
        end

        def self.parse(file)
          node = YAML.load_file(file)

          unless %w(2.1 2).include? node['version']
            fail "only version 2+ Docker Compose files are supported"
          end

          Config.new(node['services'].collect(&Service.method(:parse)),
                     node['volumes'].collect(&Volume.method(:parse)),
                     node['networks'].collect(&Network.method(:parse)))
        end
      end
    end
  end
end