require "docker/api/volume"
require "docker/api/volume_list_response"

module Docker
  module Api
    module Resources
      module Volumes
        # List volumes
        # GET /volumes
        def volumes(params = {})
          response = get("/volumes", params)
          VolumeListResponse.parse(self, response)
        end

        # Create a volume
        # POST /volumes/create
        def volume_create(config)
          response = post_json('/volumes/create', {}, config)
          Volume.parse(self, response)
        end

        # Inspect a volume
        # GET /volumes/(name)
        def volume_inspect(name)
          response = get("/volumes/#{URI.encode(name)}")
          Volume.parse(self, response)
        end

        # Remove a volume
        # DELETE /volumes/(name)
        def volume_remove(name)
          RestClient::Request.execute method: :delete,
            url: "/volumes/#{URI.encode(name)}"
          true # success
        end
      end
    end
  end
end