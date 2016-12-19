require "docker/api/image"
require "docker/api/utils"

require "docker/api/image_history_frame"
require "docker/api/image_remove_action"

require "base64"

module Docker
  module Api
    module Resources
      module Images
        # List images
        # GET /images/json
        def images(params = {})
          response = get('/images/json')
          (response || []).collect { |i| Image.parse(self, i) }
        end

        # Build image
        # POST /build
        def image_build(context_file, params = {}, auth_object = registry_config)
          raise NotImplementedError
        end

        # Create an image
        # POST /images/create
        def image_create(params = {}, auth_object = registry_config, &block)
          with_line_event_handler(block) do |handler|
            RestClient::Request.execute method: :post,
              url: resource_url('/images/create'),
              headers: {
                params: params,
                'X-Registry-Config': Base64.urlsafe_encode64(auth_object.to_json)
              },
              block_response: handler
          end
        end

        # Inspect an image
        # GET /images/(name)/json
        def image_inspect(name)
          response = get("/images/#{URI.encode(name)}/json")
          Image.parse(self, response)
        end

        # Get the history of an image
        # GET /images/(name)/history
        def image_history(name)
          response = get("/images/#{URI.encode(name)}/history")
          (response || []).collect { |f| ImageHistoryFrame.parse(self, i) }
        end

        # Push an image on the registry
        # POST /images/(name)/push
        def image_push(name, params = {}, auth_object = registry_config, &block)
          with_line_event_handler(block) do |handler|
            RestClient::Request.execute method: :post,
              url: resource_url("/images/#{URI.encode(name)}/push"),
              headers: {
                params: params,
                'X-Registry-Config': Base64.urlsafe_encode64(auth_object.to_json)
              },
              block_response: handler
          end
        end

        # Tag an image into a repository
        # POST /images/(name)/tag
        def image_tag(name, params = {})
          post_raw("/images/#{URI.encode(name)}/tag", params)
          true # success
        end

        # Remove an image
        # DELETE /images/(name)
        def image_delete(name, params = {})
          response = JSON.load(RestClient::Request.execute method: :delete,
            url: resource_url("/images/#{URI.encode(name)}"),
            headers: {
              params: params
          })
          (response || []).collect { |e| ImageRemoveAction.parse(self, e) }
        end

        # Search an image
        # GET /images/search
        def image_search(params = {})
          get("/images/search", params)
        end

        private
        def with_line_event_handler(event_block = nil)
          events = []
          handler = proc do |response|
            # Create a response stream
            io = Utils::ResponseStream.new(response)

            # Put out messages in real-time
            io.each_line do |e|
              event = JSON.load(e)
              events << event
              event_block.call(event) if event_block
            end
          end

          # Invoke callback
          yield(handler)
          events
        end
      end
    end
  end
end