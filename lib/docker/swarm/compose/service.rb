require "docker/swarm/compose/resource"

module Docker
  module Swarm
    module Compose
      class Service < Resource
        # Compose properties
        attr_accessor :build, :image, :depends_on
        # Service properties
        attr_accessor :command, :environment, :labels, :log_driver, :log_opt,
                      :networks, :user, :working_dir, :restart, :mounts

        def image_name
          "#{config.name}_#{name}"
        end

        def service_name
          "#{config.name}_#{name}"
        end

        def auto_network_name(network_name)
          if %w(bridge docker_gwbridge host ingress none).include? network_name
            network_name
          else
            "#{config.name}_#{network_name}"
          end
        end

        def to_config
          c = {
            "Name": service_name,
            "Labels": labels,
            "TaskTemplate": {
              "ContainerSpec": {
                "Image": image_name,
                "Command": command,
                # "Args": args,
                "Env": environment,
                "Dir": working_dir,
                "User": user,
                "Labels": labels,
                "Mounts": mounts,
                # "StopGracePeriod": stop_grace_period,
              },
              "LogDriver": {
                "Name": log_driver,
                "Options": log_opt
              },
              # "Resources": {
              #   "Limits": {
              #     "CPU": cpu_limit,
              #     "Memory": memory_limit
              #   },
              #   "Reservation": {
              #     "CPU": cpu_reservation,
              #     "Memory": memory_reservation
              #   }
              # },
              "RestartPolicy": {
                "Condition": restart || "none",
                # "Delay": _delay,
                # "Attempts": _attempts,
                # "Window": _window
              },
              # "Placement": placement
            },
            # "Mode": mode,
            # "UpdateConfig": {
            #   "Parallelism": update_parallelism,
            #   "Delay": update_delay,
            #   "FailureAction": update_failure_action
            # }
            "Networks": (networks || []).collect { |network_name| { "Target": auto_network_name(network_name) } },
            # "EndpointSpec": {
            #   "Mode": endpoint_mode,
            #   "Ports": endpoint_ports
            # }
          }.delete_if { |k, v| v.nil? }
          #puts JSON.dump(c)
          c
        end
      end
    end
  end
end