# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/jsonapi/version'

Gem::Specification.new do |gem|
  gem.name          = "sinatra-jsonapi"
  gem.version       = Sinatra::JSONAPI::VERSION
  gem.authors       = ["Kyle Drake"]
  gem.email         = ["kyledrake@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'json'
  gem.add_dependency 'sinatra'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'pry'
end
