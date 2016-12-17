require "docker/api/entity"

module Docker
  module Api
    class Container < Entity
      attr_accessor :id, :names, :image, :image_id, :command, :created, :state,
                    :status, :ports, :labels, :size_rw, :size_root_fs,
                    :host_config, :network_settings, :mounts,
                    :app_armor_profile, :args, :config, :driver, :exec_ids,
                    :hostname_path, :hosts_path, :log_path, :mount_label, :name,
                    :path, :process_label, :resolv_conf_path, :restart_count,
                    :graph_driver

      def inspect_container(include_size = false)
        client.container(id, {size: !!include_size}, self)
      end
    end
  end
end