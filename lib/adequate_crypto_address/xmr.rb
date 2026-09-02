# frozen_string_literal: true

require 'digest'

module AdequateCryptoAddress
  # Validates Monero addresses by decoding the Monero Base58 payload and
  # verifying the network byte, structural length, and Keccak-256 checksum.
  # References: https://docs.getmonero.org/public-address/standard-address/
  # and https://docs.getmonero.org/public-address/integrated-address/
  class Xmr
    STANDARD_LENGTH = 69   # prefix(1) + spend key(32) + view key(32) + checksum(4)
    INTEGRATED_LENGTH = 77 # standard + payment id(8)
    CHECKSUM_LENGTH = 4
    ENCODED_LENGTHS = [95, 106].freeze

    NETWORK_PREFIXES = {
      standard: { 18 => :mainnet, 53 => :testnet, 24 => :stagenet },
      integrated: { 19 => :mainnet, 54 => :testnet, 25 => :stagenet },
      subaddress: { 42 => :mainnet, 63 => :testnet, 36 => :stagenet }
    }.freeze

    attr_reader :address, :type, :network

    def initialize(address)
      @address = address
      @type = detect_type
    end

    def valid?(validated_type = nil)
      return !type.nil? unless validated_type

      type == validated_type.to_sym
    end

    # :standard, :integrated, or :subaddress when valid, otherwise nil.
    def address_type
      type
    end

    private

    def detect_type
      bytes = decode
      return nil unless bytes

      category, @network = classify(bytes.first)
      return nil unless category
      return nil unless bytes.length == expected_length(category)
      return nil unless valid_checksum?(bytes)

      category
    end

    def decode
      return nil unless ENCODED_LENGTHS.include?(address.to_s.length)

      Utils::MoneroBase58.decode(address)
    end

    def classify(prefix)
      NETWORK_PREFIXES.each do |category, prefixes|
        network = prefixes[prefix]
        return [category, network] if network
      end
      [nil, nil]
    end

    def expected_length(category)
      category == :integrated ? INTEGRATED_LENGTH : STANDARD_LENGTH
    end

    def valid_checksum?(bytes)
      body = bytes[0...-CHECKSUM_LENGTH]
      keccak256(body.pack('C*')).bytes[0, CHECKSUM_LENGTH] == bytes[-CHECKSUM_LENGTH..]
    end

    def keccak256(data)
      Digest::Keccak.new(256).digest(data)
    end
  end

  Monero = Xmr
end
