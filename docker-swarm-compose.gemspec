# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker/swarm/compose/version'

Gem::Specification.new do |spec|
  spec.name          = "docker-swarm-compose"
  spec.version       = Docker::Swarm::Compose::VERSION
  spec.authors       = ["Vincent Tavernier"]
  spec.email         = ["vince.tavernier@gmail.com"]

  spec.summary       = %q{A Docker Swarm client that scales services.}
  spec.description   = %q{This Docker client program is an attempt at scaling Docker Swarm services based on compose file-like description.}
  spec.homepage      = "https://github.com/Vince300/docker-swarm-compose"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "commander", "~> 4.4"
  spec.add_runtime_dependency "rest-client", "~> 2.0"
  spec.add_runtime_dependency "net_http_unix", "~> 0.2"
  spec.add_runtime_dependency "io-like", "~> 0.3"
end
