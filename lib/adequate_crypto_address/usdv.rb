# frozen_string_literal: true

module AdequateCryptoAddress
  class USDV < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  VemantiUSD = USDV
end
