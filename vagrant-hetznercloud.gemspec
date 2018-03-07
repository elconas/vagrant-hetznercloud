# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-hetznercloud/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-hetznercloud'
  spec.version       = VagrantPlugins::Hetznercloud::VERSION
  spec.authors       = ['Robert Heinzmann']
  spec.email         = ['reg@elconas.de']

  spec.summary       = 'Vagrant provider plugin for Hetznercloud'
  spec.description   = 'Enables Vagrant to manage machines in Hetznercloud.'
  spec.homepage      = 'https://github.com/elconas/vagrant-hetznercloud'
  spec.license       = 'APACHE-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/}) || f.match(%r{^\.})
  }

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'fog-hetznercloud', '~> 0.0.2'
  spec.add_dependency 'toml'
end
