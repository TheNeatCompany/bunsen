# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunsen/version'

Gem::Specification.new do |spec|
  spec.name          = "bunsen"
  spec.version       = Bunsen::VERSION
  spec.authors       = ["Richard Henning", "Mauricio Linhares"]
  spec.email         = ["rhenning@neat.com", "mlinhares@neat.com"]
  spec.summary       = %q{Warms mongodb indexes and collections}
  spec.description   = %q{Warms mongodb indexes and collections}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "chronic", "~> 0.10"
  spec.add_dependency "formatador", "~> 0.2"
  spec.add_dependency "mongo", "~> 1.12"
  spec.add_dependency "bson_ext", "~> 1.12"
  spec.add_dependency "thor", "~> 0.19"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
