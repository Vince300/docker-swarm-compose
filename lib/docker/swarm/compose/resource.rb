module Docker
  module Swarm
    module Compose
      class Resource
        attr_reader :name, :config

        def initialize(name, config)
          @name = name
          @config = config
        end

        def self.parse(name, node, config)
          inst = self.new(name, config)
          (node || {}).each do |k, v|
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