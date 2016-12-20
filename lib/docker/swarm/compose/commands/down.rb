require "docker/swarm/compose/commands/base"

module Docker
  module Swarm
    module Compose
      module Commands
        class Down < Base
          def run(args, options)
            config.services.each do |service|
              begin
                client.service_remove(service.service_name)
                say "removed service #{service.name}"
              rescue Docker::Api::DaemonError => e
                say "service #{service.name} not created, moving on"
              end
            end

            config.networks.each do |network|
              begin
                client.network_remove(network.network_name)
                say "removed network #{network.name}"
              rescue Docker::Api::DaemonError => e
                say "network #{network.name} not created, moving on"
              end
            end
          end
        end
      end
    end
  end
end