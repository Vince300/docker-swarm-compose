require "docker/api/entity"

module Docker
  module Api
    class Container < Entity
      def inspect_container(include_size = false)
        client.container_inspect(id, {size: !!include_size}, self)
      end

      def top(ps_args = '-ef')
        client.container_top(id, ps_args)
      end

      def logs(params = {})
        client.container_logs(id, params)
      end

      def changes
        client.container_changes(id)
      end

      def export
        client.container_export(id)
      end

      def stats(stream = false)
        client.container_stats(id, stream)
      end

      def resize(params = {})
        client.container_resize(id, params)
      end

      def start(params = {})
        client.container_start(id, params)
      end

      def stop(params = {})
        client.container_stop(id, params)
      end

      def restart(params = {})
        client.container_restart(id, params)
      end

      def kill(params = {})
        client.container_kill(id, params)
      end

      def update(config, params = {})
        client.container_update(id, config, params)
      end

      def rename(new_name)
        client.container_rename(id, new_name)
        # yay, instant update
        attributes['Name'] = new_name
        true # success
      end

      def pause
        client.container_pause(id)
      end

      def unpause
        client.container_unpause(id)
      end

      def attach(params = {})
        client.container_attach(id, params)
      end

      def wait(params = {})
        client.container_wait(id, params)
      end

      def remove(params = {})
        client.container_remove(id, params)
      end

      def archive_info(params = {})
        client.container_archive_info(id, params)
      end

      def archive_get(params = {})
        client.container_archive_get(id, params)
      end

      def archive_put(params = {})
        client.container_archive_put(id, params)
      end
    end
  end
end