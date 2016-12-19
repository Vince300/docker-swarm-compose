require "docker/api/network"
require "docker/api/network_create_response"

require "json"

module Docker
  module Api
    module Resources
      module Networks
        # List networks
        # GET /networks
        def networks(filters = {})
          response = get("/networks", filters: JSON.dump(filters))
          (response || []).collect { |n| Network.parse(self, n) }
        end

        # Inspect network
        # GET /networks/<network-id>
        def network_inspect(network_id, existing = nil)
          response = get("/networks/#{URI.encode(network_id)}")

          if existing
            existing.parse(response)
          else
            Network.parse(self, response)
          end
        end

        # Create a network
        # POST /networks/create
        def network_create(config)
          response = post_json("/networks/create", {}, config)
          NetworkCreateResponse.parse(self, response)
        end

        # Connect a container to a network
        # POST /networks/(id)/connect
        def network_connect(network_id, config)
          post_json("/networks/#{URI.encode(network_id)}/connect", {}, config)
          true # success
        end

        # Disconnect a container from a network
        # POST /networks/(id)/disconnect
        def network_disconnect(network_id, config)
          post_json("/networks/#{URI.encode(network_id)}/disconnect", {}, config)
          true # success
        end

        # Remove a network
        # DELETE /networks/(id)
        def network_remove(network_id)
          handle_errors do
            RestClient::Request.execute method: :delete,
              url: resource_url("/networks/#{URI.encode(network_id)}")
          end
          true # success
        end
      end
    end
  end
end