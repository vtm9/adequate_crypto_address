# frozen_string_literal: true

module AdequateCryptoAddress
  class WBTC < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  WrappedBitcoin = WBTC
end
