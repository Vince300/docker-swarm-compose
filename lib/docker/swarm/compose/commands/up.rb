require "docker/swarm/compose/commands/base"

module Docker
  module Swarm
    module Compose
      module Commands
        class Up < Base
          def run(args, options)
            puts config.inspect
          end
        end
      end
    end
  end
end