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

  spec.add_dependency 'base58', '~> 0.2.3'
  spec.add_dependency 'digest-sha3', '~> 1.1.0'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
