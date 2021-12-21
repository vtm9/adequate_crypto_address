# frozen_string_literal: true

module AdequateCryptoAddress
  class Cdai < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  CompoundDai = Cdai
end
