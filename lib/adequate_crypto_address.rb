require 'adequate_crypto_address/utils/bech32'
require 'adequate_crypto_address/utils/bch'

require 'adequate_crypto_address/eth'
require 'adequate_crypto_address/btc'
require 'adequate_crypto_address/bch'


module AdequateCryptoAddress

  module_function

  def valid?(address, currency, type = nil)
    address(address, currency).valid?(type)
  end

  def address(address, currency)
    AdequateCryptoAddress.const_get(currency.capitalize).new(address)
  end

  def address_type(address, currency)
    AdequateCryptoAddress.const_get(currency.capitalize).new(address).address_type
  end
end
