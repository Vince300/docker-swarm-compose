require "docker/api/auth_response"
require "docker/api/info_response"
require "docker/api/version_response"
require "docker/api/commit_response"
require "docker/api/container_exec_response"

require "docker/api/event"
require "docker/api/exec"

require "json"

module Docker
  module Api
    module Resources
      module Misc
        # Check auth configuration
        # POST /auth
        def auth(auth_body)
          AuthResponse.parse(self, post_json("/auth", {}, auth_body))
        end

        # Display system-wide information
        # GET /info
        def info
          InfoResponse.parse(self, get("/info"))
        end

        # Show the docker version information
        # GET /version
        def version
          VersionResponse.parse(self, get("/version"))
        end

        # Ping the docker server
        # GET /_ping
        def ping
          get_raw("/_ping") =~ /OK/
        end

        # Create a new image from a container's changes
        # POST /commit
        def commit(config, params = {})
          response = post_json("/commit", params, config)
          CommitResponse.parse(self, response)
        end

        # Monitor Docker's events
        # GET /events
        def events(params = {})
          handler = proc do |response|
            response.read_body do |chunk|
              yield(Event.parse(self, JSON.load(chunk)))
            end
          end

          RestClient::Request.execute(method: :get,
            url: resource_url("/events"),
            headers: { params: params },
            block_handler: handler)
          true # success
        end

        # Get a tarball containing all images in a repository
        # GET /images/(name)/get
        def images_get_repository(name)
          handle_errors do
            RestClient::Request.execute(method: :get,
                                        url: resource_url("/images/#{URI.encode(name)}/get"),
                                        raw_response: true)
          end
        end

        # Get a tarball containing all images
        # GET /images/get
        def images_get_all
          handle_errors do
            RestClient::Request.execute(method: :get,
                                        url: resource_url('/images/get'),
                                        raw_response: true)
          end
        end

        # Load a tarball with a set of images and tags into docker
        # POST /images/load
        def images_load(source, params = {})
          raise NotImplementedError
        end

        # Exec Create
        # POST /containers/(name or id)/exec
        def container_exec(id_or_name, config, params = {})
          response = post_json("/containers/#{URI.encode(id_or_name)}/exec", params, config)
          ContainerExecResponse.parse(self, response)
        end

        # Exec Start
        # POST /exec/(id)/start
        def exec_start(id, params = {})
          raise NotImplementedError
        end

        # Exec Resize
        # POST /exec/(id)/resize
        def exec_resize(id, params = {})
          post_raw("/exec/#{URI.encode(id)}/resize", params)
          true # success
        end

        # Exec Inspect
        def exec_inspect(id)
          response = get("/exec/#{URI.encode(id)}/json")
          Exec.parse(self, response)
        end
      end
    end
  end
end