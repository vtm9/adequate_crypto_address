# frozen_string_literal: true

module AdequateCryptoAddress
  class Aux < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Aux = Aux
end