# frozen_string_literal: true

module AdequateCryptoAddress
  class Shib < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  ShibaInu = Shib
end
