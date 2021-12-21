# frozen_string_literal: true

module AdequateCryptoAddress
  class XYO < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  XYOracle = XYO
end
