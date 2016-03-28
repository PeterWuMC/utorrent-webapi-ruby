# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'utorrent-webapi-ruby'
  spec.version       = '0.0.1'
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
end
