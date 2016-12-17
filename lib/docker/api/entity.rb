require "docker/api/utils"

module Docker
  module Api
    class Entity
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def self.parse(client, hash)
        inst = self.new(client)
        hash.each do |k, v|
          inst.send((Utils.snake_case(k) + '=').to_sym, v)
        end
        inst
      end
    end
  end
end