require "yaml"

require "docker/swarm/compose/service"
require "docker/swarm/compose/network"

module Docker
  module Swarm
    module Compose
      class Config
        attr_reader :services, :networks, :file, :name

        def initialize(file)
          @file = file
          @name = File.basename(File.dirname(file))
        end

        def load_resources(services, networks)
          @services = services
          @networks = networks
          self
        end

        def self.parse(file)
          node = YAML.load_file(file)

          config = Config.new(file)
          config.load_resources(
            parse_list(node['services'], Service, config),
            parse_list(node['networks'], Network, config))
        end

        private
        def self.parse_list(list_node, klass, config)
          (list_node || []).collect { |k, v| klass.parse(k, v, config) }
        end
      end
    end
  end
end