# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'state_machines-record_lifecycle'
  spec.version       = '0.0.0'
  spec.authors       = ['James Hay']
  spec.email         = %w[jaahay@gmail.com]
  spec.summary       = 'State Machines Active Record Lifecycle'
  spec.description   = 'Adds lifecycle support for ActiveRecord state machines'
  spec.homepage      = 'https://github.com/jaahay/state_machines-record_lifecycle/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.required_ruby_version = '>= 2.6'
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.1'
  spec.add_development_dependency 'appraisal', '>= 1'
  spec.add_development_dependency 'minitest', '>= 5.4.0'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
