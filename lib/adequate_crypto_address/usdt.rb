# frozen_string_literal: true

module AdequateCryptoAddress
  class USDT < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  TetherUSD = USDT
end
