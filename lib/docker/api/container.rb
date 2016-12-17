require "docker/api/entity"

module Docker
  module Api
    class Container < Entity
      attr_accessor :id, :names, :image, :image_id, :command, :created,
                    :state, :status, :ports, :labels, :size_rw, :size_root_fs,
                    :host_config, :network_settings, :mounts
    end
  end
end