require "docker/swarm/compose/resource"

module Docker
  module Swarm
    module Compose
      class Volume < Resource
        attr_accessor :driver, :driver_opts, :external, :labels

        def volume_name
          "#{config.name}_#{name}"
        end

        def to_config
          {
            "Name": volume_name,
            "Driver": driver,
            "DriverOpts": driver_opts,
            "Labels": labels
          }.delete_if { |k, v| v.nil? }
        end
      end
    end
  end
end