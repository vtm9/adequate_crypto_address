# frozen_string_literal: true

module AdequateCryptoAddress
  class Matic < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  PolygonMaticToken = Matic
end
