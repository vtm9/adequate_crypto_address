# frozen_string_literal: true

module AdequateCryptoAddress
  class Mana < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Decentraland = Mana
end
