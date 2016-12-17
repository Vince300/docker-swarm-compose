require "docker/api/container"
require "docker/api/container_create_response"
require "docker/api/container_top_response"
require "docker/api/container_change"

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
        def container_logs(id_or_name, params)
          fail "not yet implemented"
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
                                        raw_response: true)
          end
        end
      end
    end
  end
end