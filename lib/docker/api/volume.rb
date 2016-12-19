require "docker/api/entity"

module Docker
  module Api
    class Volume < Entity
      attr_accessor :name, :driver, :mountpoint, :labels, :scope, :status
    end
  end
end