# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deep/hash/struct/version'

Gem::Specification.new do |spec|
  spec.name          = "deep-hash-struct"
  spec.version       = Deep::Hash::Struct::VERSION
  spec.authors       = ["adachi"]
  spec.email         = ["haimaki4222@gmail.com"]

  spec.summary       = "Convenient hash."
<<<<<<< HEAD
  spec.description   = "We can handle data specialized for table display, storage of values can be handled like Struct corresponding to multiple layers."
=======
  spec.description   = "A slightly useful hash-like object."
>>>>>>> add merge, fetch and initialize
  spec.homepage      = "https://github.com/etiopiamokamame/deep-hash-struct"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
