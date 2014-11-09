# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forms/version'

Gem::Specification.new do |spec|
  spec.name          = "forms"
  spec.version       = Forms::VERSION
  spec.authors       = ["Robert Ross"]
  spec.email         = ["rross@digitalocean.com"]
  spec.summary       = %q{Forms is a form object library that provides the benefit of middleware}
  spec.description   = %q{Forms is a different approach to accepting user input. It allows you to avoid Callback Hell™ that traditional apps sometimes end up in.}
  spec.homepage      = "https://github.com/bobbytables/forms"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'middleware', '~> 0.1.0'
  spec.add_dependency 'uber',       '~> 0.0.10'
  spec.add_dependency 'virtus',     '~> 1.0.3'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
end
