require "yaml"

module Docker
  module Swarm
    module Compose
      module ConfigLoader
        CONFIG_FILES = %w(docker-compose.yml docker-compose.yaml)

        def self.load_config
          CONFIG_FILES.select { |file| File.exist? file }
                      .map { |file| YAML.load_file(file) }
                      .first
        end

        def config
          @config ||= ConfigLoader.load_config
          unless @config
            fail "failed to load any of #{CONFIG_FILES.join(', ')}"
          end
        end
      end
    end
  end
end
