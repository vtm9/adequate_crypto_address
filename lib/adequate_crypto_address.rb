# frozen_string_literal: true

require 'adequate_crypto_address/utils/bech32'
require 'adequate_crypto_address/utils/bch'

require 'adequate_crypto_address/altcoin'
require 'adequate_crypto_address/bch'
require 'adequate_crypto_address/eth'
require 'adequate_crypto_address/btc'
require 'adequate_crypto_address/xrp'
require 'adequate_crypto_address/dash'
require 'adequate_crypto_address/zec'
require 'adequate_crypto_address/ltc'
require 'adequate_crypto_address/monero'

module AdequateCryptoAddress
  class UnknownCurrency < StandardError; end
  module_function

  def valid?(address, currency, type = nil)
    address(address, currency).valid?(type)
  end

  def address(address, currency)
    AdequateCryptoAddress.const_get(currency.capitalize).new(address)
  rescue NameError
    raise UnknownCurrency, "Wrong currency #{currency}"
  end

  def address_type(address, currency)
    AdequateCryptoAddress.const_get(currency.capitalize).new(address).address_type
  end
end
