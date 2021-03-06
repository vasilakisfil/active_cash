# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_cash/version'

Gem::Specification.new do |spec|
  spec.name          = "active_cash"
  spec.version       = ActiveCash::VERSION
  spec.authors       = ["Filippos Vasilakis"]
  spec.email         = ["vasilakisfil@gmail.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/vasilakisfil/active_cash"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "redis-objects", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "activerecord", "~> 4.0"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "factory_girl", "~> 4.5"
  spec.add_development_dependency "database_cleaner", "~> 1.5"
  spec.add_development_dependency "fakeredis", "~> 0.5"
  spec.add_development_dependency "test_after_commit", "~> 0.4"
  spec.add_development_dependency "pry", "~> 0.10"
end
