# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'perforated/version'

Gem::Specification.new do |spec|
  spec.name        = 'perforated'
  spec.version     = Perforated::VERSION
  spec.authors     = ['Parker Selbert']
  spec.email       = ['parker@sorentwo.com']
  spec.homepage    = 'https://github.com/sorentwo/perforated'
  spec.license     = 'MIT'
  spec.description = %(Intellgent json collection caching)
  spec.summary     = <<-SUMMARY
    The most expensive part of serving a JSON request is converting the
    serialized records into JSON. Perforated cache handles the messy task of
    storing and retrieving all JSON for a particular set of models as
    effeciently as possible.
  SUMMARY

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '> 4.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3'
end
