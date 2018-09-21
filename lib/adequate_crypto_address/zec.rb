# frozen_string_literal: true

module AdequateCryptoAddress
  class Zec < Altcoin
    EXPECTED_LENGTH = 52
    ADDRESS_TYPES = { prod: %w[1cb8 1cbd], test: %w[1d25 1cba] }.freeze
  end
  Zcash = Zec
end
