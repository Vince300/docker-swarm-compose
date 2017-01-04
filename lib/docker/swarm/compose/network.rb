require "docker/swarm/compose/resource"

require "json"

module Docker
  module Swarm
    module Compose
      class Network < Resource
        attr_accessor :driver, :driver_opts, :enable_ipv6, :ipam, :internal,
                      :labels, :external

        def network_name
          "#{config.name}_#{name}"
        end

        def driver
          @driver || 'overlay'
        end

        def to_config
          c = {
            "Name" => network_name,
            "CheckDuplicate" => true,
            "Driver" => driver,
            "Internal" => internal,
            "IPAM" => ipam || {
              'Driver' => 'default',
              'Options' => {},
              'Config' => []
            },
            "EnableIPv6" => enable_ipv6,
            "Options" => driver_opts,
            "Labels" => labels
          }.delete_if { |k, v| v.nil? }
        end
      end
    end
  end
end