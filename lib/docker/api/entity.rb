require "docker/api/utils"

module Docker
  module Api
    class Entity
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def self.parse(client, hash)
        self.new(client).parse(hash)
      end

      def parse(hash)
        hash.each do |k, v|
          self.send((Utils.snake_case(k) + '=').to_sym, v)
        end
        self
      end
    end
  end
end