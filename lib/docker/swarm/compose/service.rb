require "docker/swarm/compose/resource"
require "docker/swarm/compose/hash_utils"

module Docker
  module Swarm
    module Compose
      class Service < Resource
        # Compose properties
        attr_accessor :build, :image, :depends_on, :mode
        # Service properties
        attr_accessor :command, :environment, :labels, :log_driver, :log_opt,
                      :networks, :user, :working_dir, :restart, :mounts
        # Added attributes
        attr_accessor :args, :stop_grace_period, :cpu_limit, :memory_limit,
                      :cpu_reservation, :memory_reservation, :restart_delay,
                      :restart_max_attempts, :restart_window, :placement
        # Even more attributes
        attr_accessor :update_parallelism, :update_delay, :update_failure_action,
                      :replicas, :endpoint_mode, :ports

        def mounts
          @mounts || []
        end

        def networks
          @networks || []
        end

        def restart
          @restart || "none"
        end

        def restart_max_attempts
          @restart || 0
        end

        def replicas
          @replicas || 1
        end

        def ports
          @ports || []
        end

        def placement
          @placement || []
        end

        def mode
          @mode || 'replicated'
        end

        def image_name
          "#{config.name}_#{name}"
        end

        def tagged_image_name(tag = 'latest')
          "#{image_name}:#{tag}"
        end

        def service_name
          "#{config.name}_#{name}"
        end

        def to_config(client, current_mode = nil)
          cnf = {
            "Name" => service_name,
            "Labels" => labels,
            "TaskTemplate" => {
              "ContainerSpec" => {
                "Image" => tagged_image_name,
                "Command" => command,
                "Args" => args,
                "Env" => environment,
                "Dir" => working_dir,
                "User" => user,
                "Labels" => labels,
                "Mounts" => mounts.collect { |mount|
                  m = mount.dup
                  m['Source'] = File.expand_path(File.join('..', m['Source']), config.file) unless m['Source'].start_with? "/"
                  m
                },
                "StopGracePeriod" => stop_grace_period
              },
              "LogDriver" => {
                "Name" => log_driver,
                "Options" => log_opt
              },
              "Resources" => {
                "Limits" => {
                  "CPU" => cpu_limit,
                  "Memory" => memory_limit
                },
                "Reservation" => {
                  "CPU" => cpu_reservation,
                  "Memory" => memory_reservation
                }
              },
              "RestartPolicy" => {
                "Condition" => restart,
                "Delay" => restart_delay,
                "MaxAttempts" => restart_max_attempts,
                "Window" => restart_window
              },
              "Placement" => {
                "Constraints" => placement
              }
            },
            "Mode" => {},
            "UpdateConfig" => {
              "Parallelism" => update_parallelism,
              "Delay" => update_delay,
              "FailureAction" => update_failure_action
            },
            "Networks" => networks.collect { |network_name| {
              "Target" => "#{config.name}_#{network_name}",
              "Aliases" => [name]}
            },
            "EndpointSpec" => {
              "Mode" => endpoint_mode,
              "Ports" => ports.map { |port_spec|
                parsed = port_spec.split(' =>')
                if parsed.length == 3
                  {'Protocol' => parsed[0], 'PublishedPort' => parsed[1].to_i, 'TargetPort' => parsed[2].to_i}
                elsif parsed.length == 2
                  {'Protocol' => 'tcp', 'PublishedPort' => parsed[0].to_i, 'TargetPort' => parsed[1].to_i}
                elsif parsed.length == 1
                  {'Protocol' => 'tcp', 'PublishedPort' => parsed[0].to_i, 'TargetPort' => parsed[0].to_i}
                else
                  warn "port spec '#{port_spec}' is invalid, ignoring it"
                  nil
                end
              }.select { |spec| not spec.nil? }.to_a
            }
          }

          # Add labels
          add_swarm_labels(client, cnf)
          add_swarm_labels(client, cnf['TaskTemplate']['ContainerSpec'])

          # Build the mode node
          if current_mode
            if current_mode['Replicated'] and mode == 'global'
              fail "service mode change not allowed"
            elsif current_mode['Global'] and mode == 'replicated'
              fail "service mode change not allowed"
            else
              # If no change in mode type, keep the current one
              # TODO: set replicas from command-line?
              cnf['Mode'] = current_mode
              if cnf['Mode']['Replicated']
                cnf['Mode']['Replicated']['Replicas'] = [replicas, cnf['Mode']['Replicated']['Replicas']].max
              end
            end
          else
            if mode == 'global'
              cnf['Mode'] = {"Global" => {}}
            else
              cnf['Mode'] = {"Replicated" => {"Replicas" => replicas}}
            end
          end

          HashUtils.compact(cnf, recurse: true, exclude: %w(Global))
        end

        private
        def add_swarm_labels(client, cnf)
          cnf['Labels'] ||= {}
          cnf['Labels']['com.github.vince300.docker-swarm-compose.master-image-id'] = client.image_inspect(tagged_image_name).id
        end
      end
    end
  end
end