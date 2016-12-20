require "docker/swarm/compose/commands/base"

module Docker
  module Swarm
    module Compose
      module Commands
        class Build < Base
          def run(args, options)
            services_to_build = []
            services_to_pull = []

            # Find services to build
            config.services.each do |service|
              if service.build
                say "#{service.name} needs to be built"
                services_to_build << service
              elsif service.image
                say "#{service.name} needs to be pulled"
                services_to_pull << service
              end
            end

            # Then build them (sequential for now)
            services_to_build.each do |service|
              build_service(service)
            end

            # And pull them (sequential for now)
            services_to_pull.each do |service|
              pull_service(service)
            end

            say "build complete!"
          end

          private

          def event_stream
            # TODO: pty handling
            handler = proc do |event|
              if event['stream']
                puts event['stream']
              elsif event['status']
                if event['id']
                  unless event['progress']
                    puts "#{event['id']}: #{event['status']}"
                  end
                else
                  # output the status
                  puts event['status']
                end
              else
                puts event.inspect
              end
            end

            yield(handler)
          end

          def pull_service(service)
            # Name of the target image
            image_name = "#{config.name}_#{service.name}"
            
            # Add :latest if needed
            from_image_name = service.image
            from_image_name += ":latest" unless from_image_name =~ /:\w+$/

            # Notify user
            say "pulling #{service.name} from #{from_image_name} to #{image_name}"

            begin
              event_stream do |handler|
                client.image_create(fromImage: from_image_name, &handler)
              end

              # Then tag it
              client.image_tag(from_image_name, repo: image_name, tag: 'latest')
            rescue Docker::Api::DaemonError => e
              say "=> failed pulling the image: #{e.message}"
            end
          end

          def build_service(service)
            # Name of the target image
            image_name = "#{config.name}_#{service.name}"

            # Notify user
            say "building #{service.name} to #{image_name}"

            if service.build.is_a? String
              # Just build from a context directory
              base_directory = File.dirname(config.file)

              context_directory = if service.build == '.'
                base_directory
              else
                File.expand_path(service.build, base_directory)
              end

              say "=> using context from #{context_directory}"

              Tempfile.open do |tmpfile|
                Dir.chdir(context_directory) do
                  system("tar", "czf", tmpfile.path, *Dir.glob("*"))
                end

                say "=> sending build context to Docker daemon"
                begin
                  event_stream do |handler|
                    client.image_build(tmpfile, t: image_name, &handler)
                  end
                rescue Docker::Api::DaemonError => e
                  warn "=> failed building the image: #{e.message}"
                end
              end
            else
              warn "complex build context are not yet supported!"
            end
          end
        end
      end
    end
  end
end