require "docker/api/entity"

module Docker
  module Api
    class Image < Entity
      attr_accessor :id, :container, :comment, :comment, :os, :architecture,
                    :parent, :container_config, :docker_version, :virtual_size,
                    :size, :author, :created, :graph_driver, :repo_digests,
                    :repo_tags, :config, :root_fs, :labels, :parent_id

      def inspect_image
        client.image_inspect(id, {}, self)
      end
    end
  end
end