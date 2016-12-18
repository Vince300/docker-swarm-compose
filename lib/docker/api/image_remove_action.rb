require "docker/api/entity"

module Docker
  module Api
    class ImageRemoveAction < Entity
      attr_accessor :untagged, :deleted
    end
  end
end