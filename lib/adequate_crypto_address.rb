# frozen_string_literal: true

require 'adequate_crypto_address/utils/bech32'
require 'adequate_crypto_address/utils/bch'
require 'adequate_crypto_address/utils/xlm'
require 'adequate_crypto_address/utils/monero_base58'

require 'adequate_crypto_address/altcoin'
require 'adequate_crypto_address/bch'
require 'adequate_crypto_address/eth'
require 'adequate_crypto_address/btc'
require 'adequate_crypto_address/xrp'
require 'adequate_crypto_address/dash'
require 'adequate_crypto_address/zec'
require 'adequate_crypto_address/ltc'
require 'adequate_crypto_address/ton'
require 'adequate_crypto_address/xmr'
require 'adequate_crypto_address/doge'
require 'adequate_crypto_address/sol'
require 'adequate_crypto_address/xlm'
require 'adequate_crypto_address/ada'

module AdequateCryptoAddress
  class UnknownCurrency < StandardError; end
  module_function

  def valid?(address, currency, type = nil)
    address(address, currency).valid?(type)
  end

  def address(address, currency)
    klass = currency_class(currency)
    raise UnknownCurrency, "Wrong currency #{currency}" unless klass

    klass.new(address)
  end

  # Public contract: returns the detected address type as a Symbol when the
  # address is valid for the currency, or nil when it is not.
  def address_type(address, currency)
    address(address, currency).address_type
  end

  # Resolve a currency name (string or symbol, any case) to its validator class.
  # Only classes defined directly on this module that implement the validator
  # interface are eligible, so malformed input can never be mistaken for a
  # currency and NoMethodError is never swallowed as UnknownCurrency.
  def currency_class(currency)
    const_name = currency.to_s.capitalize
    return nil unless const_defined?(const_name, false)

    klass = const_get(const_name)
    return nil unless klass.is_a?(Class) && klass.method_defined?(:valid?)

    klass
  end
end
