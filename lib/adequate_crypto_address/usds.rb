# frozen_string_literal: true

module AdequateCryptoAddress
  class Usds < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  StablyUSD = Usds
end
