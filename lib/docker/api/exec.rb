require "docker/api/entity"

module Docker
  module Api
    class Exec < Entity
      attr_accessor :can_remove, :container_id, :detach_keys, :exit_code, :id,
                    :open_stderr, :open_stdin, :open_stdout, :process_config,
                    :running
    end
  end
end