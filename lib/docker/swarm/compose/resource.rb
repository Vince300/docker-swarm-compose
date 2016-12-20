module Docker
  module Swarm
    module Compose
      class Resource
        attr_reader :name

        def initialize(name)
          @name = name
        end

        def self.parse(args)
          name, node = args
          inst = self.new(name)
          node.each do |k, v|
            if inst.respond_to? "#{k}="
              inst.send("#{k}=".to_sym, v)
            else
              warn "ignoring unsupported attribute '#{k}' in resource #{name}"
            end
          end
          inst
        end
      end
    end
  end
end