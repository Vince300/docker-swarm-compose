require "docker/api/entity"

module Docker
  module Api
    class CommitResponse < Entity
      attr_accessor :id
    end
  end
end