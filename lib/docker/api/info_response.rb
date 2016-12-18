require "docker/api/entity"

module Docker
  module Api
    class InfoResponse < Entity
      attr_accessor :architecture, :cluster_store, :cgroup_driver, :containers,
                    :containers_running, :containers_stopped,
                    :containers_paused, :cpu_cfs_period, :cpu_cfs_quota, :debug,
                    :docker_root_dir, :driver, :driver_status,
                    :experimental_build, :http_proxy, :https_proxy, :id,
                    :ipv4_forwarding, :images, :index_server_address,
                    :init_path, :init_sha1, :kernel_memory, :kernel_version,
                    :labels, :mem_total, :memory_limit, :ncpu,
                    :nevents_listener, :nfd, :ngoroutines, :name, :no_proxy,
                    :oom_kill_disable, :ostype, :operating_system, :plugins,
                    :registry_config, :security_options, :server_version,
                    :swap_limit, :system_status, :system_time, :cpushares,
                    :cpuset, :bridge_nf_iptables, :bridge_nf_ip6tables,
                    :execution_driver, :logging_driver, :cluster_advertise,
                    :runtimes, :default_runtime, :swarm, :live_restore_enabled
    end
  end
end