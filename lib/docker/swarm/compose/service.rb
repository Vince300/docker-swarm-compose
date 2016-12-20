require "docker/swarm/compose/resource"

module Docker
  module Swarm
    module Compose
      class Service < Resource
        attr_accessor :build, :cap_add, :cap_drop, :command, :cgroup_parent,
                      :container_name, :devices, :depends_on, :dns, :dns_search,
                      :tmpfs, :entrypoint, :env_file, :environment, :expose,
                      :external_links, :extra_hosts, :group_add, :image,
                      :isolation, :labels, :links, :logging, :log_driver,
                      :log_opt, :net, :network_mode, :networks, :pid, :ports,
                      :security_opt, :stop_signal, :ulimits, :volumes,
                      :volume_driver

        # Ignoring :extends on purpose for now.
        # Ignoring :volumes_from on purpose for now.

        attr_accessor :cpu_shares, :cpu_quota, :cpuset, :domainname, :hostname,
                      :hostname, :ipc, :mac_address, :mem_limit, :memswap_limit,
                      :oom_score_adj, :privileged, :read_only, :restart,
                      :shm_size, :stdin_open, :tty, :user, :working_dir

        def image_name
          "#{config.name}_#{name}"
        end
      end
    end
  end
end