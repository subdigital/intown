# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tourbus/version'

Gem::Specification.new do |gem|
  gem.name          = "tourbus"
  gem.version       = Tourbus::VERSION
  gem.authors       = ["Ben Scheirman"]
  gem.email         = ["ben@scheirman.com"]
  gem.description   = %q{A client for the Bandsintown API.}
  gem.summary       = %q{Supports Bandsintown API version 1.1}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '~> 2.12.0'
  gem.add_development_dependency 'vcr', '~> 2.4.0'
  gem.add_development_dependency 'webmock', '~> 1.9.3'
  gem.add_development_dependency 'pry'

  gem.add_dependency 'httparty', '~> 0.10.0'
  gem.add_dependency 'hashie', '~> 2.0.0'
end
