module Docker
  module Swarm
    module Compose
      module HashUtils
        def self.compact(hash, opts = {})
          opts[:exclude] ||= []
          hash.inject({}) do |new_hash, (k,v)|
            if !v.nil?
              nv = opts[:recurse] && v.class == Hash ? compact(v, opts) : v
              if nv.class != Hash || nv.length > 0 || opts[:exclude].include?(k)
                new_hash[k] = nv
              end
            end
            new_hash
          end
        end
      end
    end
  end
end