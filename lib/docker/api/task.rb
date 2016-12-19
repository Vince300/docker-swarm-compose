require "docker/api/entity"

module Docker
  module Api
    class Task < Entity
      def inspect_task
        client.task_inspect(id, self)
      end
    end
  end
end