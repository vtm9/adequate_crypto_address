# frozen_string_literal: true

module AdequateCryptoAddress
  class TUSD < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  TrueUSD = TUSD
end
