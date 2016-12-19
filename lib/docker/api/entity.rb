require "docker/api/utils"

module Docker
  module Api
    class Entity
      attr_reader :client
      attr_accessor :attributes

      @@attr_lookup = {}

      def initialize(client)
        @client = client
        @attributes = {}
      end

      def self.parse(client, hash)
        self.new(client).parse(hash)
      end

      def parse(hash)
        @attributes = hash

        @attributes.each do |k, v|
          setter = (Utils.snake_case(k) + '=').to_sym
          if respond_to? setter
            send(setter, v)
          end
        end

        self
      end

      def method_missing(meth, *args)
        attr_name = meth.id2name
        setter = attr_name[-1] == '='
        raw_name = if setter then attr_name[0..-2] else attr_name end

        unless @@attr_lookup.include? raw_name
          @attributes.each do |k, v|
            if Utils.snake_case(k) == raw_name
              @@attr_lookup[raw_name] = k
              break
            end
          end
        end

        attribute_name = @@attr_lookup[raw_name]

        if @attributes.include? attribute_name
          if setter
            if args.length != 1
              raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 1)"
            end

            return (@attributes[attribute_name] = args[0])
          else
            if args.length != 0
              raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
            end

            return (@attributes[attribute_name])
          end
        end

        super
      end
    end
  end
end