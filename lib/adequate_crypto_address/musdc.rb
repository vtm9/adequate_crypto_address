# frozen_string_literal: true

module AdequateCryptoAddress
  class Musdc < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  DMMUSDC = Musdc
end
