require "docker/swarm/compose/commands/base"

module Docker
  module Swarm
    module Compose
      module Commands
        class Up < Base
          def run(args, options)
            failure_count = 0

            # Check that all images are accessible
            config.services.each do |service|
              begin
                image = client.image_inspect(service.image_name)
              rescue Docker::Api::DaemonError => e
                failure_count += 1
                warn "could not find image for #{service.name}"
              end
            end

            if failure_count > 0
              fail "one or more images were not found, the application can not be started"
            end

            # Create networks
            config.networks.each do |network|
              begin
                existing_network = client.network_inspect(network.network_name)
                say "network #{network.name} already exists"
              rescue Docker::Api::DaemonError => e
                if network.external
                  failure_count += 1
                  warn "network #{network.network_name} is external and has not been created yet"
                else
                  begin
                    say "creating network #{network.name}"

                    if network.driver != 'overlay'
                      warn "WARNING: network #{network.name} is not using the overlay driver, this will not do what you expect"
                    end

                    client.network_create(network.to_config)
                  rescue Docker::Api::DaemonError => ee
                    failure_count += 1
                    warn "could not create network #{network.name}: #{ee.message}"
                  end
                end
              end
            end

            if failure_count > 0
              fail "one or more networks could not be created, the application can not be started"
            end

            # Finally, create(update) services
            processed_services = []
            delayed_services = []

            config.services.each do |service|
              if service.depends_on and service.depends_on.length > 0
                # has dependencies
                delayed_services << service
              else
                # has no dependencies
                unless start_service(service)
                  failure_count += 1
                  break
                end
                processed_services << service.name
              end
            end

            if failure_count == 0
              while delayed_services.length > 0
                delayed_services.each do |service|
                  if service.depends_on.all? { |s| processed_services.include? s }
                    delayed_services.delete service
                    unless start_service(service)
                      failure_count += 1
                      break
                    end
                    processed_services << service.name
                  end
                end
              end
            end

            if failure_count > 0
              fail "one or more services could not be created, the application can not be started"
            end
         end

          private
          def start_service(service)
            begin
              existing_service = client.service_inspect(service.service_name)
              say "service #{service.name} already exists, updating"

              begin
                existing_service.update(service.to_config, version: existing_service.version['Index'])
                return true
              rescue Docker::Api::DaemonError => e
                warn "failed to update service #{service.name}: #{e.message}"
                return false
              end
            rescue Docker::Api::DaemonError => e
              say "creating service #{service.name}"
              begin
                client.service_create(service.to_config)
                return true
              rescue Docker::Api::DaemonError => ee
                warn "failed to create service #{service.name}: #{ee.message}"
                return false
              end
            end
          end
        end
      end
    end
  end
end