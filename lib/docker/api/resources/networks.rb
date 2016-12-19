require "docker/api/network"

module Docker
  module Api
    module Resources
      module Networks
        # List networks
        # GET /networks
        def networks(params = {})
          response = get("/networks", params)
          (response || []).collect { |n| Network.parse(self, n) }
        end
      end
    end
  end
end