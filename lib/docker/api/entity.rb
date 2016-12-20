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

        update_attributes do
          @attributes.each do |k, v|
            setter = (Utils.snake_case(k) + '=').to_sym
            if respond_to? setter
              send(setter, v)
            end
          end
        end

        self
      end

      def self.nested_entities(attribute, entity_class)
        define_method(attribute) do
          value = instance_variable_get("@#{attribute}")
          instance_variable_set("@#{attribute}", value = []) if value.nil?
          value
        end

        define_method("#{attribute}=") do |value|
          if not value.nil? and value.length > 0
            if value[0].is_a? Hash
              value = value.collect { |item| entity_class.parse(client, item) }
            end
          end

          instance_variable_set("@#{attribute}", value || [])
        end
      end

      def method_missing(meth, *args)
        attr_name, setter, raw_name = attribute_properties(meth)

        lookup_attribute(raw_name) do |attribute_name|
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
        end

        super
      end

      def respond_to_missing?(meth, include_private = false)
        attr_name, setter, raw_name = attribute_properties(meth)
        attribute_name = lookup_attribute(raw_name)

        @attributes.include? attribute_name || super
      end

      private
      def attribute_properties(meth_name)
        attr_name = meth_name.id2name
        setter = attr_name[-1] == '='
        raw_name = if setter then attr_name[0..-2] else attr_name end

        return attr_name, setter, raw_name
      end

      def update_attributes
        begin
          @updating_attributes = true
          yield
        ensure
          @updating_attributes = false
        end
      end

      def lookup_attribute(raw_name)
        if raw_name == 'id'
          @@attr_lookup[raw_name] = %w(id Id ID).select { |w| @attributes.include? w }.first
        else
          unless @@attr_lookup.include? raw_name
            @attributes.each do |k, v|
              if Utils.snake_case(k) == raw_name
                @@attr_lookup[raw_name] = k
                break
              end
            end
          end
        end

        if block_given?
          yield(@@attr_lookup[raw_name])
        else
          @@attr_lookup[raw_name]
        end
      end
    end
  end
end