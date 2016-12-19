require "docker/api/volume"
require "docker/api/volume_list_response"

require "json"

module Docker
  module Api
    module Resources
      module Volumes
        # List volumes
        # GET /volumes
        def volumes(filters = {})
          response = get("/volumes", filters: JSON.dump(filters))
          VolumeListResponse.parse(self, response)
        end

        # Create a volume
        # POST /volumes/create
        def volume_create(config = {})
          response = post_json('/volumes/create', {}, config)
          Volume.parse(self, response)
        end

        # Inspect a volume
        # GET /volumes/(name)
        def volume_inspect(name, existing = nil)
          response = get("/volumes/#{URI.encode(name)}")

          if existing
            existing.parse(response)
          else
            Volume.parse(self, response)
          end
        end

        # Remove a volume
        # DELETE /volumes/(name)
        def volume_remove(name)
          handle_errors do
            RestClient::Request.execute method: :delete,
              url: resource_url("/volumes/#{URI.encode(name)}")
          end
          true # success
        end
      end
    end
  end
end