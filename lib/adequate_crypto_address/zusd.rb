# frozen_string_literal: true

module AdequateCryptoAddress
  class ZUSD < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  ZytaraUSD = ZUSD
end
