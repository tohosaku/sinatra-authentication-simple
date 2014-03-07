# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/authentication/simple/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra-authentication-simple"
  spec.version       = Sinatra::Authentication::Simple::VERSION
  spec.authors       = ["Takashi Kato"]
  spec.email         = ["tkatou95@jcs-gifu.co.jp"]
  spec.description   = %q{Simple authentication extension for Sinatra}
  spec.summary       = %q{Simple authentication extension for Sinatra}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency             "warden"
  spec.add_development_dependency "bundler", "~> 1.1"
  spec.add_development_dependency "rake"
end
