require "docker/api/entity"

module Docker
  module Api
    class VersionResponse < Entity
      attr_accessor :version, :os, :kernel_version, :go_version, :git_commit,
                    :arch, :api_version, :build_time, :experimental
    end
  end
end