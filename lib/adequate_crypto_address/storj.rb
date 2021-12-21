# frozen_string_literal: true

module AdequateCryptoAddress
  class Storj < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Storj = Storj
end
