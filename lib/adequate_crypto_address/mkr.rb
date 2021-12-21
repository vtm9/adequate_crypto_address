# frozen_string_literal: true

module AdequateCryptoAddress
  class Mkr < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Maker = Mkr
end
