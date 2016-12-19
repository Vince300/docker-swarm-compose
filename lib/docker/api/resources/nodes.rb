require "docker/api/node"

module Docker
  module Api
    module Resources
      module Nodes
        # List nodes
        # GET /nodes
        def nodes(filters)
          response = get("/nodes", filters: JSON.dump(filters))
          (response || []).collect { |n| Node.parse(self, response) }
        end

        # Inspect a node
        # GET /nodes/<id>
        def node_inspect(id, existing = nil)
          response = get("/nodes/#{URI.encode(id)}")
          
          if existing
            existing.parse(response)
          else
            Node.parse(self, response)
          end
        end

        # Remove a node
        # DELETE /nodes/(id)
        def node_remove(id, params = {})
          handle_errors do
            RestClient::Request.execute method: :delete,
              url: resource_url("/nodes/#{URI.encode(id)}"),
              headers: { params: params }
          end
          true # success
        end

        # Update a node
        # POST /nodes/(id)/update
        def node_update(id, config, params = {})
          post_json_raw("/nodes/#{URI.encode(id)}/update", params, config)
          true # success
        end
      end
    end
  end
end