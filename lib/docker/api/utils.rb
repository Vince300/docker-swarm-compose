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
        end

        def unbuffered_read(length)
          if @mybuf.nil? || @mybuf.length == 0
            begin
              # Empty buffer, read some data
              if @mybuf
                @mybuf += @fiber.resume
              else
                @mybuf = @fiber.resume
              end

              # Buffer still nil?, ended
              raise EOFError.new if @mybuf.nil?
            rescue FiberError
              # End of request body
              raise EOFError.new
            end
          end

          # Find out how many bytes we can read from the buffer
          read_len = [length, @mybuf.length].min

          # Shrink buffer
          data = @mybuf.byteslice(0, read_len)
          @mybuf = @mybuf.byteslice(read_len)

          return data
        end
      end

      def self.snake_case(str)
        str.gsub(/([a-z])([A-Z])/, '\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end