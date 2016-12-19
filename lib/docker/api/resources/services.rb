require "docker/api/service"
require "docker/api/service_create_response"

require "json"

module Docker
  module Api
    module Resources
      module Services
        # List services
        # GET /services
        def services(filters = {})
          response = get("/services", filters: JSON.dump(filters))
          (response || []).collect { |s| Service.parse(self, service) }
        end

        # Create a service
        # POST /services/create
        def service_create(config)
          handle_errors do
            response = RestClient::Request.execute method: :post,
              url: resource_url("/services/create"),
              headers: {
                'X-Registry-Config': registry_header(registry_config),
                content_type: :json
              },
              payload: config.to_json
            ServiceCreateResponse.parse(self, response)
          end
        end

        # Remove a service
        # DELETE /services/(id or name)
        def service_remove(id_or_name)
          handle_errors do
            RestClient::Request.execute method: :delete,
              url: resource_url("/services/#{URI.encode(id_or_name)}")
            true # success
          end
        end

        # Inspect a service
        # GET /services/(id or name)
        def service_inspect(id_or_name)
          response = get("/services/#{URI.encode(id_or_name)}")
          Service.parse(self, response)
        end

        # Update a service
        # POST /services/(id or name)/update
        def service_update(id_or_name, config, params = {})
          post_json_raw("/services/#{URI.encode(id_or_name)}/update", params, config)
          true # success
        end
      end
    end
  end
end