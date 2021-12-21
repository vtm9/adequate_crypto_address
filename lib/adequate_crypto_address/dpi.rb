# frozen_string_literal: true

module AdequateCryptoAddress
  class Dpi < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  DeFiPulseIndex = Dpi
end
