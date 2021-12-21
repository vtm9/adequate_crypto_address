# frozen_string_literal: true

module AdequateCryptoAddress
  class Chz < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  ChiliZ = Chz
end
