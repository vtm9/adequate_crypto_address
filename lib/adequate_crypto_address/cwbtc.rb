# frozen_string_literal: true

module AdequateCryptoAddress
  class Cwbtc < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  CompoundWrappedBTC = Cwbtc
end
