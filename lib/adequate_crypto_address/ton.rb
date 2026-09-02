# frozen_string_literal: true

module AdequateCryptoAddress
  # Validates TON user-friendly addresses (TEP-2). The 48-character Base64URL
  # form decodes to 36 bytes: tag(1) + workchain(1) + account_id(32) + crc16(2).
  class Ton
    ADDRESS_LENGTH = 48
    DECODED_LENGTH = 36
    BOUNCEABLE_TAG = 0x11
    NON_BOUNCEABLE_TAG = 0x51
    TEST_FLAG = 0x80
    VALID_WORKCHAINS = [0x00, 0xff].freeze

    attr_reader :address, :type

    def initialize(address)
      @address = address
      @type = address_type
    end

    def valid?(type = nil)
      if type
        address_type == type.to_sym
      else
        !address_type.nil?
      end
    end

    # :ton_mainnet or :ton_testnet when valid, otherwise nil.
    def address_type
      bytes = decode
      return nil unless bytes

      tag = bytes[0]
      return nil unless valid_tag?(tag)
      return nil unless VALID_WORKCHAINS.include?(bytes[1])
      return nil unless checksum_valid?(bytes)

      tag.anybits?(TEST_FLAG) ? :ton_testnet : :ton_mainnet
    end

    private

    def decode
      return nil unless valid_encoding?

      # Base64URL decode via core unpack (the base64 gem is only a wrapper).
      bytes = address.tr('-_', '+/').unpack1('m0')&.bytes
      bytes if bytes && bytes.length == DECODED_LENGTH
    rescue ArgumentError
      nil
    end

    def valid_encoding?
      address.is_a?(String) &&
        address.length == ADDRESS_LENGTH &&
        address.match?(/\A[A-Za-z0-9_-]{#{ADDRESS_LENGTH}}\z/)
    end

    def valid_tag?(tag)
      [BOUNCEABLE_TAG, NON_BOUNCEABLE_TAG].include?(tag & ~TEST_FLAG)
    end

    def checksum_valid?(bytes)
      crc = crc16(bytes[0...34])
      [(crc >> 8) & 0xff, crc & 0xff] == bytes[34..35]
    end

    # CRC16-CCITT (XMODEM): polynomial 0x1021, initial value 0x0000.
    def crc16(bytes)
      bytes.reduce(0) do |crc, byte|
        crc ^= byte << 8
        8.times { crc = crc.anybits?(0x8000) ? ((crc << 1) ^ 0x1021) & 0xffff : (crc << 1) & 0xffff }
        crc
      end
    end
  end

  Toncoin = Ton
end
