# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'format_engine/version'

Gem::Specification.new do |spec|
  spec.name          = "format_engine"
  spec.version       = FormatEngine::VERSION
  spec.authors       = ["Peter Camilleri"]
  spec.email         = ["peter.c.camilleri@gmail.com"]
  spec.summary       = %q{An engine for string formatting and parsing.}
  spec.description   = %q{An engine for string formatting and parsing like the strftime and strptime methods.}
  spec.homepage      = "http://teuthida-technologies.com/"
  spec.license       = "MIT"

  raw_list           = `git ls-files`.split($/)
  spec.files         = raw_list.keep_if {|entry| !entry.start_with?("docs") }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', "~> 5.5.1"
  spec.add_development_dependency 'minitest_visible', "~> 0.0.2"
  spec.add_development_dependency 'rdoc', "~> 4.0.1"
end
