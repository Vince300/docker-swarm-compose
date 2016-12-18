require "docker/api/entity"

module Docker
  module Api
    class ImageHistoryFrame < Entity
      attr_accessor :id, :created, :created_by, :tags, :size, :comment
    end
  end
end