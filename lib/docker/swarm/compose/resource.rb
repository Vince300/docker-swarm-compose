module Docker
  module Swarm
    module Compose
      class Resource
        attr_reader :name

        def initialize(name)
          @name = name
        end

        def self.parse(name, node)
          self.new(name)
          node.each do |k, v|
            if respond_to? "#{k}="
              send("#{k}=".to_sym, v)
            else
              warn "ignoring unsupported attribute '#{k}' in resource #{name}"
            end
          end
        end
      end
    end
  end
end