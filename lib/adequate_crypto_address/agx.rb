# frozen_string_literal: true

module AdequateCryptoAddress
  class Agx < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  AgxCoin = Agx
end
