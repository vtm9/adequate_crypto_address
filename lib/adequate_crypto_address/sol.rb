# frozen_string_literal: true

module AdequateCryptoAddress
  class Sol
    ALPHABET_TYPE = :bitcoin
    MAX_LENGTH = 64 # a 32-byte key encodes to at most 44 Base58 characters

    attr_reader :address

    def initialize(address_string)
      @address = address_string
    end

    def valid?(_type = nil)
      valid_format?
    end

    # :solana when the address decodes to a 32-byte key, otherwise nil.
    def address_type
      valid_format? ? :solana : nil
    end

    private

    def valid_format?
      return false if address.to_s.length > MAX_LENGTH

      decoded = Base58.base58_to_binary(address, ALPHABET_TYPE)
      decoded.bytesize == 32
    rescue StandardError
      false
    end
  end

  Solana = Sol
end
