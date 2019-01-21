# frozen_string_literal: true

module AdequateCryptoAddress
  class Ltc < Altcoin
    ADDRESS_TYPES = { prod: %w[30 05 32], test: %w[6f c4 3a] }.freeze
  end
  Litecoin = Ltc
end
