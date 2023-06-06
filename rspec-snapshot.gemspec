# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/image_snapshot/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-image-snapshot'
  spec.version       = RSpec::ImageSnapshot::VERSION
  spec.authors       = ['Joseph Harrison-Lim']
  spec.email         = ['josephharrisonlim@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = 'RSpec Image Snapshot Matcher'
  spec.description   = 'Adding image snapshot testing to RSpec'
  spec.homepage      = 'https://github.com/jharrilim/rspec-image-snapshot'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'mini_magick', '>= 4.0.0'
  spec.add_dependency 'rspec', '> 3.0.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
