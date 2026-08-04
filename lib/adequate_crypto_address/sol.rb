# frozen_string_literal: true

module AdequateCryptoAddress
  class Sol
    ALPHABET_TYPE = :bitcoin

    attr_reader :address

    def initialize(address_string)
      @address = address_string
    end

    def valid?(_type = nil)
      valid_format?
    end

    def address_type; end

    private

    def valid_format?
      decoded = Base58.base58_to_binary(address, ALPHABET_TYPE)
      decoded.bytesize == 32
    rescue StandardError
      false
    end
  end

  Solana = Sol
end
