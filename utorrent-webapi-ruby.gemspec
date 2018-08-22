# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'u_torrent/version'


Gem::Specification.new do |spec|
  spec.name          = 'utorrent-webapi-ruby'
  spec.version       = UTorrent::VERSION
  spec.authors       = ['Peter Wu']
  spec.email         = ['petergenius@gmail.com']
  spec.description   = %q{UTorrent webapi ruby library}
  spec.summary       = %q{Communicate to utorrent via webapi in ruby}
  spec.homepage      = 'https://github.com/PeterWuMC/utorrent-webapi-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'
end
