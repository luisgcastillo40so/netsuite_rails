# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = "netsuite_rails"
  s.version       = "0.1.0"
  s.authors       = ["Michael Bianco"]
  s.email         = ["mike@cliffsidemedia.com"]
  s.summary       = %q{Write Rails applications that sync with NetSuite}
  s.homepage      = ""
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'netsuite', '~> 0.3'
  s.add_dependency 'rails', '>= 3.2.16'

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
