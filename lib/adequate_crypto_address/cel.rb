# frozen_string_literal: true

module AdequateCryptoAddress
  class Cel < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Celsius = Cel
end
