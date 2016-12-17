require "docker/api/container"
require "docker/api/create_response"

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
        # GET /containers/(name or id)/json
        def container(name_or_id, params = {}, existing = nil)
          response = get("/containers/#{URI.encode(name_or_id)}/json", params)

          if existing
            existing.parse(response)
          else
            Container.parse(self, response)
          end
        end
      end
    end
  end
end