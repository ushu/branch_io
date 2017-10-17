# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'branch_io/version'

Gem::Specification.new do |spec|
  spec.name          = "branch_io"
  spec.version       = BranchIO::VERSION
  spec.authors       = ["Aurélien Noce"]
  spec.email         = ["aurelien.noce@imagine-app.fr"]

  spec.summary       = %q{A Client for the Branch.io deep linking public API}
  spec.description   = %q{This wrapper allows you to create and update deep links on branch.io, using the public REST API.}
  spec.homepage      = "https://github.com/ushu/branch_io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.13"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.1"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rspec-simplecov"
  spec.add_development_dependency "rubocop", "~> 0.50.0"
  spec.add_development_dependency "simplecov"
end
