# frozen_string_literal: true

module AdequateCryptoAddress
  class Sushi < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  SushiToken = Sushi
end
