# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adequate_crypto_address/version'

Gem::Specification.new do |spec|
  spec.name          = 'adequate_crypto_address'
  spec.version       = AdequateCryptoAddress::VERSION
  spec.authors       = ['vtm']

  spec.summary     = 'Ruby helpers for validating cryptocurrency addresses.'
  spec.description = 'Provides Ruby helpers to validate cryptocurrency addresses across common chains.'
  spec.homepage = 'https://github.com/vtm9/adequate_crypto_address'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0'
  spec.files = Dir.chdir(__dir__) do
    Dir['{bin,lib}/**/*', 'LICENSE.txt', 'README.md'].select { |path| File.file?(path) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'base58', '~> 0.2'
  spec.add_dependency 'keccak', '~> 1.3'
end
