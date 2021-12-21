# frozen_string_literal: true

module AdequateCryptoAddress
  class Comp < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Compound = Comp
end
