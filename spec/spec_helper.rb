$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "docker/swarm/compose"

RSpec::Matchers.define :named_object do |expected|
  match do |actual|
    actual.name == expected
  end

  description do
    "an object named '#{expected}'"
  end
end

PREFIX = "rb-docker-api"

def docker_name(name)
  "#{PREFIX}-#{name}"
end
