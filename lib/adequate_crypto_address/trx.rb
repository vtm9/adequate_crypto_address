# frozen_string_literal: true

module AdequateCryptoAddress
  # TRON mainnet addresses are Base58Check with the 0x41 version byte and a
  # four-byte double-SHA256 checksum (25 bytes total, rendered as a 34-character
  # string starting with "T"). https://developers.tron.network/docs/account
  class Trx < Altcoin
    ADDRESS_TYPES = { prod: %w[41] }.freeze
  end

  Tron = Trx
end
