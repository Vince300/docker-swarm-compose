require 'io/like'

module Docker
  module Api
    module Utils
      class ResponseStream
        include IO::Like

        def initialize(response)
          # Using a Fiber because it is what we need
          @fiber = Fiber.new do
            response.read_body do |chunk|
              Fiber.yield chunk
            end
            nil
          end
          self.fill_size = 16
        end

        def unbuffered_read(length)
          if @mybuf.nil? || @mybuf.length == 0
            begin
              # Empty buffer, read some data
              read_data = @fiber.resume

              # Detect end of stream
              raise EOFError.new if read_data.nil?

              if @mybuf
                @mybuf += read_data
              else
                @mybuf = read_data
              end
            rescue FiberError
              # End of request body
              raise EOFError.new
            end
          end

          # Find out how many bytes we can read from the buffer
          read_len = [length, @mybuf.length].min

          # Shrink buffer
          data = @mybuf.byteslice(0, read_len)
          @mybuf = @mybuf.byteslice(read_len, @mybuf.length - read_len)

          return data
        end
      end

      def self.snake_case(str)
        str.gsub(/([a-z0-9])([A-Z])/, '\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end