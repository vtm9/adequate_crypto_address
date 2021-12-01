# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adequate_crypto_address/version'

Gem::Specification.new do |spec|
  spec.name          = 'adequate_crypto_address'
  spec.version       = AdequateCryptoAddress::VERSION
  spec.authors       = ['vtm']
  spec.email         = ['vtmilyakov@yandex.ru']

  spec.summary     = 'A Ruby Library for dealing with validation cryptocurrency adresses.'
  spec.description = 'A Ruby Library for dealing with validation cryptocurrency adresses.'
  spec.homepage = 'https://github.com/vtm9/adequate_crypto_address'

  spec.license = 'MIT'
  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.require_paths = ['lib']

  spec.add_dependency 'base58', '~> 0.2'
  spec.add_dependency 'keccak', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
end
