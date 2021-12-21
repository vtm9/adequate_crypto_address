# frozen_string_literal: true

module AdequateCryptoAddress
  class Cprx < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  CryptoPerx = Cprx
end
