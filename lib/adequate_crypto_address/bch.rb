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
        [:P2SH, 5],
        [:P2PKH, 0],
        [:P2SHTestnet, 196],
        [:P2PKHTestnet, 111]
      ],
      cash: [
        [:P2SH, 8],
        [:P2PKH, 0],
        [:P2SHTestnet, 8],
        [:P2PKHTestnet, 0]
      ]
    }.freeze
    DEFAULT_PREFIX = :bitcoincash

    attr_reader :address, :raw_address, :type, :payload, :prefix, :digest

    def initialize(address_string)
      @raw_address = address_string
      @address = normalize(address_string)
    end

    def valid?(validated_type = nil)
      if validated_type
        type == validated_type.to_sym
      else
        !type.nil?
      end
    end

    private

    def normalize(address_string)
      from_cash_string(address_string)
    rescue InvalidCashAddress
      begin
        from_legacy_string(address_string)
      rescue ::AdequateCryptoAddress::InvalidAddress
        nil
      end
    end

    def from_legacy_string(address_string)
      decoded = nil
      begin
        decoded = Base58.base58_to_binary(address_string, :bitcoin).bytes
      rescue StandardError
        raise(InvalidLegacyAddress, 'Could not decode legacy address')
      end
      @type = address_type(:legacy, decoded[0].to_i)[0]
      @payload = decoded[1..-5]
      @digest = decoded[-4..-1]
      @prefix = DEFAULT_PREFIX
      cash_address
    end

    def from_cash_string(address_string)
      if address_string.upcase != address_string && address_string.downcase != address_string
        raise(InvalidCashAddress, 'Cash address contains uppercase and lowercase characters')
      end

      address_string = address_string.downcase
      address_string = "#{DEFAULT_PREFIX}:#{address_string}" if !address_string.include?(':')

      @prefix, base32string = address_string.split(':')
      decoded = b32decode(base32string)

      raise(InvalidCashAddress, 'Bad cash address checksum') if !verify_cash_checksum(decoded)

      converted = convertbits(decoded, 5, 8)
      @type = address_type(:cash, converted[0].to_i)[0]
      @payload = converted[1..-7]
      cash_address
    end

    def address_type(address_type, type)
      TYPE_MAP[address_type].each do |mapping|
        return mapping if mapping.include?(type)
      end

      raise(AdequateCryptoAddress::InvalidAddress, 'Could not determine address type')
    end

    def legacy_address
      type_int = address_type(:legacy, type)[1]
      input = code_list_to_string([type_int] + payload + Array(digest))
      input += Digest::SHA256.digest(Digest::SHA256.digest(input))[0..3] unless digest
      Base58.binary_to_base58(input, :bitcoin)
    end

    def cash_address
      type_int = address_type(:cash, type)[1]
      p = [type_int] + payload
      p = convertbits(p, 8, 5)
      checksum = calculate_cash_checksum(p)
      "#{prefix}:#{b32encode(p + checksum)}"
    end

    def verify_cash_checksum(payload)
      polymod(expanded_prefix + payload) == 0
    rescue TypeError
      raise InvalidCashAddress
    end
  end

  Bitcoincash = Bch
end
