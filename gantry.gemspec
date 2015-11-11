lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gantry/version'

Gem::Specification.new do |spec|
  spec.name          = 'gantry'
  spec.version       = Gantry::VERSION
  spec.authors       = ['Sebastian Boehm']
  spec.email         = ['sebastian@sometimesfood.org']
  spec.summary       = 'Deploy docker images on physical machines.'
  spec.description   = <<EOS
A tool to deploy docker images to virtual or physical machines.
EOS
  spec.homepage      = 'https://github.com/sometimesfood/gantry'
  spec.license       = 'MIT'

  spec.files         = Dir['{bin,lib,test}/**/*',
                           'Rakefile',
                           'README.md',
                           'NEWS.md',
                           'LICENSE'] & `git ls-files -z`.split("\0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
