# frozen_string_literal: true

module AdequateCryptoAddress
  class Aave < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  AaveToken = Aave
end
