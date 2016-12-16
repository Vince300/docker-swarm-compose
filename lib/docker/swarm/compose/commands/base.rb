require "docker/swarm/compose/config_loader"

module Docker
  module Swarm
    module Compose
      module Commands
        class Base
          include ConfigLoader

          def run(args, options)
            fail "command not yet implemented"
          end
        end
      end
    end
  end
end