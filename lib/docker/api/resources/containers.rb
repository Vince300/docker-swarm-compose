require "docker/api/container"
require "docker/api/create_response"
require "docker/api/top_response"

module Docker
  module Api
    module Resources
      module Containers
        # List containers
        # GET /containers/json
        def containers(params = {})
          get('/containers/json', params).collect { |c| Container.parse(self, c) }
        end

        # Create a container
        # POST /containers/create
        def create_container(config, params = {})
          response = post_json('/containers/create', params, config)
          CreateResponse.parse(self, response)
        end

        # Inspect a container
        # GET /containers/(id or name)/json
        def container(id_or_name, params = {}, existing = nil)
          response = get("/containers/#{URI.encode(id_or_name)}/json", params)

          if existing
            existing.parse(response)
          else
            Container.parse(self, response)
          end
        end

        # List processes running inside a container
        # GET /containers/(id or name)/top
        def top_container(id_or_name, ps_args = '-ef')
          response = get("/containers/#{URI.encode(id_or_name)}/top", ps_args: ps_args)
          TopResponse.parse(self, response)
        end
      end
    end
  end
end