# frozen_string_literal: true

module AdequateCryptoAddress
  class Amp < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  AmpToken = Amp
end
