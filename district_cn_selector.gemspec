# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'district_cn_selector/version'

Gem::Specification.new do |spec|
  spec.name          = "district_cn_selector"
  spec.version       = DistrictCnSelector::VERSION
  spec.authors       = ["kehao"]
  spec.email         = ["kehao.qiu@gmail.com"]
  spec.description   = %q{地区选择器}
  spec.summary       = %q{地区选择器}
  #spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "rails", ">= 3.2.6"
  spec.add_dependency "jquery-rails"
  spec.add_dependency "district_cn",">= 1.0.2"
end
