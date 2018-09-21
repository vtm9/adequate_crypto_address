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

    def address_type(address_code, address_type)
      TYPE_MAP[address_code].each do |mapping|
        return mapping if mapping.include?(address_type)
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

    alias address cash_address

    private

    def normalize
      begin
        from_cash_string
      rescue InvalidCashAddress
        from_legacy_string
      end
    rescue AdequateCryptoAddress::InvalidAddress
      nil
    end

    def from_cash_string
      if (raw_address.upcase != raw_address) && (raw_address.downcase != raw_address)
        raise(InvalidCashAddress, 'Cash address contains uppercase and lowercase characters')
      end

      @raw_address = raw_address.downcase
      @raw_address = "#{DEFAULT_PREFIX}:#{raw_address}" if !raw_address.include?(':')

      @prefix, base32string = raw_address.split(':')
      decoded = b32decode(base32string)

      raise(InvalidCashAddress, 'Bad cash address checksum') if !verify_cash_checksum(decoded)

      converted = convertbits(decoded, 5, 8)
      @type = address_type(:cash, converted[0].to_i)[0]
      @payload = converted[1..-7]

      @type = :p2shtest if prefix == 'bchtest' && type == :p2sh
      @type = :p2pkhtest if prefix == 'bchtest' && type == :p2pkh
    end

    def from_legacy_string
      decoded = nil
      begin
        decoded = Base58.base58_to_binary(raw_address, :bitcoin).bytes
      rescue StandardError
        raise(InvalidLegacyAddress, 'Could not decode legacy address')
      end

      @type = address_type(:legacy, decoded[0].to_i)[0]
      @payload = decoded[1..-5]
      @digest = decoded[-4..-1]
      @prefix = DEFAULT_PREFIX

      @type = :p2shtest if prefix == 'bchtest' && type == :p2sh
      @type = :p2pkhtest if prefix == 'bchtest' && type == :p2pkh
      @prefix = 'bchtest' if [:p2shtest, :p2pkhtest].include?(type)
    end
  end

  Bitcoincash = Bch
end
