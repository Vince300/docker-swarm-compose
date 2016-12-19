require "docker/api/task"

require "json"

module Docker
  module Api
    module Resources
      module Tasks
        # List tasks
        # GET /tasks
        def tasks(filters = {})
          response = get("/tasks", filters: JSON.dump(filters))
          (response || []).collect { |t| Task.parse(self, t) }
        end

        # Inspect a task
        # GET /tasks/(task id)
        def task_inspect(task_id, existing = nil)
          response = get("/tasks/#{URI.encode(task_id)}")

          if existing
            existing.parse(response)
          else
            Task.parse(self, response)
          end
        end
      end
    end
  end
end