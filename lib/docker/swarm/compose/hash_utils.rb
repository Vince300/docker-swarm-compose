module Docker
  module Swarm
    module Compose
      module HashUtils
        def self.compact(hash, opts = {})
          hash.inject({}) do |new_hash, (k,v)|
            if !v.nil?
              nv = opts[:recurse] && v.class == Hash ? compact(v, opts) : v
              new_hash[k] = nv if nv.class != Hash || nv.length > 0
            end
            new_hash
          end
        end
      end
    end
  end
end