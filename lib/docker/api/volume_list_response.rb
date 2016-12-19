require "docker/api/entity"
require "docker/api/volume"

module Docker
  module Api
    class VolumeListResponse < Entity
      nested_entities :volumes, Volume
    end
  end
end