require "docker/api/container"
require "docker/api/container_change"
require "docker/api/container_create_response"
require "docker/api/container_top_response"
require "docker/api/container_update_response"

module Docker
  module Api
    module Resources
      module Containers
        # List containers
        # GET /containers/json
        def containers(params = {})
          response = get('/containers/json', params)
          (response || []).collect { |c| Container.parse(self, c) }
        end

        # Create a container
        # POST /containers/create
        def container_create(config, params = {})
          response = post_json('/containers/create', params, config)
          ContainerCreateResponse.parse(self, response)
        end

        # Inspect a container
        # GET /containers/(id or name)/json
        def container_inspect(id_or_name, params = {}, existing = nil)
          response = get("/containers/#{URI.encode(id_or_name)}/json", params)

          if existing
            existing.parse(response)
          else
            Container.parse(self, response)
          end
        end

        # List processes running inside a container
        # GET /containers/(id or name)/top
        def container_top(id_or_name, ps_args = '-ef')
          response = get("/containers/#{URI.encode(id_or_name)}/top", ps_args: ps_args)
          ContainerTopResponse.parse(self, response)
        end

        # Get container logs
        # GET /containers/(id or name)/log
        def container_logs(id_or_name, params = {})
          raise NotImplementedError
        end

        # Inspect changes on a container's filesystem
        # GET /containers/(id or name)/changes
        def container_changes(id_or_name)
          response = get("/containers/#{URI.encode(id_or_name)}/changes")
          (response || []).collect { |c| ContainerChange.parse(self, c) }
        end

        # Export a container
        # GET /containers/(id or name)/export
        def container_export(id_or_name)
          handle_errors do
            RestClient::Request.execute(method: :get,
                                        url: resource_url("/containers/#{id_or_name}/export"),
                                        raw_response: true).file
          end
        end

        # Get container stats based on resource usage
        # GET /containers/(id or name)/stats
        def container_stats(id_or_name, stream = false)
          raise NotImplementedError if stream

          # Return raw parsed response
          get("/containers/#{URI.encode(id_or_name)}/stats")
        end

        # Resize a container TTY
        # POST /containers/(id or name)/resize
        def container_resize(id_or_name, params = {})
          post_raw("/containers/#{URI.encode(id_or_name)}/resize", params)
          true # sucess
        end

        # Start a container
        # POST /containers/(id or name)/start
        def container_start(id_or_name, params = {})
          post_raw("/containers/#{URI.encode(id_or_name)}/start", params)
          true # sucess
        end

        # Stop a container
        # POST /containers/(id or name)/stop
        def container_stop(id_or_name, params = {})
          post_raw("/containers/#{URI.encode(id_or_name)}/stop", params)
          true # sucess
        end

        # Restart a container
        # POST /containers/(id or name)/restart
        def container_restart(id_or_name, params = {})
          post_raw("/containers/#{URI.encode(id_or_name)}/restart", params)
          true # sucess
        end

        # Kill a container
        # POST /containers/(id or name)/kill
        def container_kill(id_or_name, params = {})
          post_raw("/containers/#{URI.encode(id_or_name)}/kill", params)
          true # sucess
        end

        # Update a container
        # POST /containers/(id or name)/update
        def container_update(id_or_name, config, params = {})
          response = post_json("/containers/#{URI.encode(id_or_name)}/update", params, config)
          ContainerUpdateResponse.parse(self, response)
        end

        # Rename a container
        # POST /containers/(id or name)/rename
        def container_rename(id_or_name, new_name)
          post_raw("/containers/#{URI.encode(id_or_name)}/rename", name: new_name)
          true # sucess
        end

        # Pause a container
        # POST /containers/(id or name)/pause
        def container_pause(id_or_name)
          post_raw("/containers/#{URI.encode(id_or_name)}/pause")
          true # sucess
        end

        # Unpause a container
        # POST /containers/(id or name)/unpause
        def container_unpause(id_or_name)
          post_raw("/containers/#{URI.encode(id_or_name)}/unpause")
          true # sucess
        end

        # Attach to a container
        # POST /containers/(id or name)/attach
        def container_attach(id_or_name, params = {})
          raise NotImplementedError
        end

        # Wait a container
        # POST /containers/(id or name)/wait
        def container_wait(id_or_name, params = {})
          response = post_json("/containers/#{URI.encode(id_or_name)}/wait")
          response['StatusCode']
        end

        # Remove a container
        # DELETE /containers/(id or name)
        def container_remove(id_or_name, params = {})
          handle_errors do
            RestClient::Request.execute method: :delete,
              url: "/containers/#{URI.encode(id_or_name)}",
              headers: { params: params }
          end
          true # success
        end

        # Retrieving information about files and folders in a container
        # HEAD /containers/(id or name)/archive
        def container_archive_info(id_or_name, params = {})
          raise NotImplementedError
        end

        # Get an archive of a filesystem resource in a container
        # GET /containers/(id or name)/archive
        def container_archive_get(id_or_name, params = {})
          raise NotImplementedError
        end

        # Extract an archive of files or folders to a directory in a container
        # PUT /containers/(id or name)/archive
        def container_archive_put(id_or_name, params = {})
          raise NotImplementedError
        end
      end
    end
  end
end