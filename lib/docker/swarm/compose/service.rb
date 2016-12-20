require "docker/swarm/compose/resource"
require "docker/swarm/compose/hash_utils"

module Docker
  module Swarm
    module Compose
      class Service < Resource
        # Compose properties
        attr_accessor :build, :image, :depends_on
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

        def image_name
          "#{config.name}_#{name}"
        end

        def tagged_image_name(tag = 'latest')
          "#{image_name}:#{tag}"
        end

        def service_name
          "#{config.name}_#{name}"
        end

        def to_config(current_mode = nil)
          HashUtils.compact({
            "Name": service_name,
            "Labels": labels,
            "TaskTemplate": {
              "ContainerSpec": {
                "Image": tagged_image_name,
                "Command": command,
                "Args": args,
                "Env": environment,
                "Dir": working_dir,
                "User": user,
                "Labels": labels,
                "Mounts": mounts,
                "StopGracePeriod": stop_grace_period
              },
              "LogDriver": {
                "Name": log_driver,
                "Options": log_opt
              },
              "Resources": {
                "Limits": {
                  "CPU": cpu_limit,
                  "Memory": memory_limit
                },
                "Reservation": {
                  "CPU": cpu_reservation,
                  "Memory": memory_reservation
                }
              },
              "RestartPolicy": {
                "Condition": restart,
                "Delay": restart_delay,
                "MaxAttempts": restart_max_attempts,
                "Window": restart_window
              },
              "Placement": placement
            },
            "Mode": current_mode || {
              "Replicated": {
                "Replicas": replicas
              }
            },
            "UpdateConfig": {
              "Parallelism": update_parallelism,
              "Delay": update_delay,
              "FailureAction": update_failure_action
            },
            "Networks": networks.collect { |network_name| {
              "Target": "#{config.name}_#{network_name}",
              "Aliases": [ name ] }
            },
            "EndpointSpec": {
              "Mode": endpoint_mode,
              "Ports": ports.map { |port_spec|
                parsed = port_spec.split(':')
                if parsed.length == 3
                  { 'Protocol': parsed[0], 'PublishedPort': parsed[1].to_i, 'TargetPort': parsed[2].to_i }
                elsif parsed.length == 2
                  { 'Protocol': 'tcp', 'PublishedPort': parsed[0].to_i, 'TargetPort': parsed[1].to_i }
                elsif parsed.length == 1
                  { 'Protocol': 'tcp', 'PublishedPort': parsed[0].to_i, 'TargetPort': parsed[0].to_i }
                else
                  warn "port spec '#{port_spec}' is invalid, ignoring it"
                  nil
                end
              }.select { |spec| not spec.nil? }.to_a
            }
          }, recurse: true)
        end
      end
    end
  end
end