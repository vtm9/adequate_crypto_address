# frozen_string_literal: true

module AdequateCryptoAddress
  class B21 < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  B21Token = B21
end
