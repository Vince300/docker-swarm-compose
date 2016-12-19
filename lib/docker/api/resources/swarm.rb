require "docker/api/swarm_info"

module Docker
  module Api
    module Resources
      module Swarm
        # Inspect swarm
        # GET /swarm
        def swarm_inspect
          response = get("/swarm")
          SwarmInfo.parse(self, response)
        end

        # Initialize a new swarm
        # POST /swarm/init
        def swarm_init(config)
          post_json("/swarm/init", {}, config)
        end

        # Join an existing swarm
        # POST /swarm/join
        def swarm_join(config)
          post_json_raw("/swarm/join", {}, config)
          true # success
        end

        # Leave a swarm
        # POST /swarm/leave
        def swarm_leave(params = {})
          post_raw("/swarm/leave", params)
          true # success
        end

        # Update a swarm
        # POST /swarm/update
        def swarm_update(config, params = {})
          post_json_raw("/swarm/update", params, config)
          true # success
        end
      end
    end
  end
end