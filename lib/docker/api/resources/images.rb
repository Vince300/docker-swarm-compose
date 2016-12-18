require "docker/api/image"
require "docker/api/utils"

require "base64"

module Docker
  module Api
    module Resources
      module Images
        def default_registry_config
          { "https://index.docker.io/v1/": {} }
        end

        # List images
        # GET /images/json
        def images(params = {})
          response = get('/images/json')
          (response || []).collect { |i| Image.parse(self, i) }
        end

        # Build image
        # POST /build
        def image_build(context_file, params = {})
          fail "not yet implemented"
        end

        # Create an image
        # POST /images/create
        def image_create(params = {}, auth_object = default_registry_config)
          events = []
          handler = proc do |response|
            # Create a response stream
            io = Utils::ResponseStream.new(response)

            # Put out messages in real-time
            io.each_line do |e|
              event = JSON.load(e)
              events << event
              yield(event) if block_given?
            end
          end

          RestClient::Request.execute method: :post,
            url: resource_url('/images/create'),
            headers: {
              params: params,
              'X-Registry-Config': Base64.urlsafe_encode64(auth_object.to_json)
            },
            block_response: handler
          events
        end
      end
    end
  end
end