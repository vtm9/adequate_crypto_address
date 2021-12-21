# frozen_string_literal: true

module AdequateCryptoAddress
  class Ceth < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  CompoundEther = Ceth
end
