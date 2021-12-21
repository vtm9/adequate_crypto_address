# frozen_string_literal: true

module AdequateCryptoAddress
  class USDC < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  USDCoin = USDC
end
