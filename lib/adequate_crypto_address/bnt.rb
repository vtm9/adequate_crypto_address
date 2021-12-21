# frozen_string_literal: true

module AdequateCryptoAddress
  class Bnt < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Bancor = Bnt
end
