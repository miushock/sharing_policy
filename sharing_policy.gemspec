# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sharing_policy/version'

Gem::Specification.new do |spec|
  spec.name          = "sharing_policy"
  spec.version       = SharingPolicy::VERSION
  spec.authors       = ["Miushock"]
  spec.email         = ["miushock@gmail.com"]
  spec.summary       = %q{freelog sharing policy}
  spec.description   = %q{describe later}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 2.6"

  spec.add_dependency "activesupport", "~> 4.0.0"
end
