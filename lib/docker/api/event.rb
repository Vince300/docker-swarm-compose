require "docker/api/entity"

module Docker
  module Api
    class Event < Entity
      attr_accessor :status, :id, :from, :type, :action, :actor, :time,
                    :time_nano
    end
  end
end