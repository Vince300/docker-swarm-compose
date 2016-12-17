require "docker/api/entity"

module Docker
  module Api
    class TopResponse < Entity
      attr_accessor :titles, :processes

      def processes
        @parsed_processes ||= @processes.collect do |fields|
          Hash[*titles.zip(fields).flatten]
        end
      end
    end
  end
end