require "docker/swarm/compose/config_loader"
require "docker/api/client"

require "commander"

module Docker
  module Swarm
    module Compose
      module Commands
        class Base
          include ConfigLoader
          include Commander::Methods

          def client
            @client ||= Docker::Api::Client.new
          end

          def run(args, options)
            fail "command not yet implemented"
          end
        end
      end
    end
  end
end