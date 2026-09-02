# frozen_string_literal: true

require 'base58'
require 'digest'

module AdequateCryptoAddress
  class InvalidAddress < StandardError; end

  class Bch
    class InvalidLegacyAddress < ::AdequateCryptoAddress::InvalidAddress; end
    class InvalidCashAddress < ::AdequateCryptoAddress::InvalidAddress; end
    include ::AdequateCryptoAddress::Utils::Bch

    TYPE_MAP = {
      legacy: [
        [:p2sh, 5],
        [:p2pkh, 0],
        [:p2shtest, 196],
        [:p2pkhtest, 111]
      ],
      cash: [
        [:p2sh, 8],
        [:p2pkh, 0],
        [:p2shtest, 8],
        [:p2pkhtest, 0]
      ]
    }.freeze
    DEFAULT_PREFIX = :bitcoincash
    CASH_PREFIXES = %w[bitcoincash bchtest bchreg].freeze
    # CashAddr size bits (version byte bits 2..0) mapped to the hash length in bytes.
    CASH_HASH_SIZES = { 0 => 20, 1 => 24, 2 => 28, 3 => 32, 4 => 40, 5 => 48, 6 => 56, 7 => 64 }.freeze
    LEGACY_LENGTH = 25 # 1 version byte + 20 hash bytes + 4 checksum bytes
    MAX_LENGTH = 120

    attr_reader :raw_address, :type, :payload, :prefix, :digest

    def initialize(address)
      @raw_address = address
      normalize
    end

    def valid?(validated_type = nil)
      if validated_type
        type == validated_type.to_sym
      else
        !type.nil?
      end
    end

    # Public contract: the detected legacy/cash type Symbol, or nil when invalid.
    def address_type
      type
    end

    def legacy_address
      type_int = type_mapping(:legacy, type)[1]
      input = code_list_to_string([type_int] + payload + Array(digest))
      input += Digest::SHA256.digest(Digest::SHA256.digest(input))[0..3] unless digest
      Base58.binary_to_base58(input, :bitcoin)
    end

    def cash_address
      type_int = type_mapping(:cash, type)[1]
      p = [type_int] + payload
      p = convertbits(p, 8, 5)
      checksum = calculate_cash_checksum(p)
      "#{prefix}:#{b32encode(p + checksum)}"
    end

    alias address cash_address

    private

    def type_mapping(address_code, address_type)
      TYPE_MAP[address_code].each do |mapping|
        return mapping if mapping.include?(address_type)
      end

      raise(AdequateCryptoAddress::InvalidAddress, 'Could not determine address type')
    end

    def normalize
      return unless raw_address.is_a?(String)
      return if raw_address.length > MAX_LENGTH

      begin
        from_cash_string
      rescue InvalidCashAddress
        from_legacy_string
      end
    rescue AdequateCryptoAddress::InvalidAddress
      nil
    end

    def from_cash_string
      validate_cash_address_case!

      @raw_address = raw_address.downcase
      @raw_address = "#{DEFAULT_PREFIX}:#{raw_address}" unless raw_address.include?(':')

      @prefix, base32string = raw_address.split(':')
      raise(InvalidCashAddress, 'Unsupported cash address prefix') unless CASH_PREFIXES.include?(prefix)

      assign_cash_payload(decode_cash_payload(base32string))
    end

    def assign_cash_payload(payload_bytes)
      version = payload_bytes.first
      raise(InvalidCashAddress, 'Invalid cash address version byte') unless valid_cash_version?(version, payload_bytes)

      @payload = payload_bytes[1..]
      @type = cash_type(version)
      @type = testnet_type(type) if prefix == 'bchtest'
    end

    # Version byte layout: bit 7 reserved (must be 0), bits 6..3 type, bits 2..0 size.
    def valid_cash_version?(version, payload_bytes)
      return false unless version&.nobits?(0x80)
      return false unless cash_type(version)

      expected = CASH_HASH_SIZES[version & 0x07]
      (payload_bytes.length - 1) == expected
    end

    def cash_type(version)
      { 0 => :p2pkh, 1 => :p2sh }[(version >> 3) & 0x0f]
    end

    def from_legacy_string
      decoded = decode_legacy_address
      raise(InvalidLegacyAddress, 'Invalid legacy address length') unless decoded.length == LEGACY_LENGTH
      raise(InvalidLegacyAddress, 'Bad legacy address checksum') unless valid_legacy_checksum?(decoded)

      @type = type_mapping(:legacy, decoded[0].to_i)[0]
      @payload = decoded[1..-5]
      @digest = decoded[-4..]
      @prefix = DEFAULT_PREFIX
      @prefix = 'bchtest' if [:p2shtest, :p2pkhtest].include?(type)
    end

    def valid_legacy_checksum?(decoded)
      body = code_list_to_string(decoded[0...-4])
      Digest::SHA256.digest(Digest::SHA256.digest(body))[0, 4] == code_list_to_string(decoded[-4..])
    end

    def validate_cash_address_case!
      return if raw_address.upcase == raw_address || raw_address.downcase == raw_address

      raise(InvalidCashAddress, 'Cash address contains uppercase and lowercase characters')
    end

    def decode_cash_payload(base32string)
      decoded = b32decode(base32string)
      raise(InvalidCashAddress, 'Invalid cash address encoding') if decoded.empty? || decoded.include?(nil)
      raise(InvalidCashAddress, 'Bad cash address checksum') unless verify_cash_checksum(decoded)

      # Drop the eight 5-bit checksum symbols, then map the payload back to bytes.
      payload = convertbits(decoded[0...-8], 5, 8, pad: false)
      raise(InvalidCashAddress, 'Invalid cash address payload') unless payload

      payload
    end

    def decode_legacy_address
      Base58.base58_to_binary(raw_address, :bitcoin).bytes
    rescue StandardError
      raise(InvalidLegacyAddress, 'Could not decode legacy address')
    end

    def testnet_type(address_type)
      { p2sh: :p2shtest, p2pkh: :p2pkhtest }.fetch(address_type)
    end
  end

  Bitcoincash = Bch
end
