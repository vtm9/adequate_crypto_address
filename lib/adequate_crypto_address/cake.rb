# frozen_string_literal: true

module AdequateCryptoAddress
  # ?
  class Cake < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  PancakeSwapToken = Cake
end
