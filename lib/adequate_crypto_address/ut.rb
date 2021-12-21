# frozen_string_literal: true

module AdequateCryptoAddress
  class Ut < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  UtilityToken = Ut
end
