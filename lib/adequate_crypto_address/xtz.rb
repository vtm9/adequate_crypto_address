# frozen_string_literal: true

module AdequateCryptoAddress
  # Tezos addresses are Base58Check with a four-byte double-SHA256 checksum and
  # multi-byte version prefixes: tz1/tz2/tz3 implicit accounts and KT1 originated
  # (contract) accounts, each wrapping a 20-byte hash (27 bytes total).
  # https://tezos.gitlab.io/user/key-management.html
  class Xtz < Altcoin
    EXPECTED_LENGTH = 54 # 27 bytes rendered as hex

    ADDRESS_TYPES = {
      implicit: %w[06a19f 06a1a1 06a1a4], # tz1, tz2, tz3
      originated: %w[025a79] # KT1
    }.freeze
  end

  Tezos = Xtz
end
