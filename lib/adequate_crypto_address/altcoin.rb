# frozen_string_literal: true

module AdequateCryptoAddress
  # simple class for common altcoin addresses like legacy btc, ripple, dash, zec, etc.
  class Altcoin
    EXPECTED_LENGTH = 50
    ADDRESS_TYPES = {}.freeze
    ALPHABET_TYPE = :bitcoin

    attr_reader :address, :type
    alias raw_address address

    def initialize(address)
      @address = address
      @type = address_type
    end

    def valid?(validated_type = nil)
      if validated_type
        type == validated_type.to_sym
      else
        !type.nil?
      end
    end

    private

    attr_reader :decoded

    def address_type
      @decoded = begin
              decode_base58
                 rescue StandardError
                   nil
            end
      if decoded && decoded.bytesize == self.class::EXPECTED_LENGTH && valid_address_checksum?
        self.class::ADDRESS_TYPES.each do |net_type, net_prefixes|
          net_prefixes.each do |net_prefix|
            return net_type if decoded.start_with?(net_prefix)
          end
        end
      end
      nil
    end

    def decode_base58
      Base58.base58_to_binary(address, self.class::ALPHABET_TYPE).each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
    end

    def valid_address_checksum?
      return false unless decoded

      checksum(decoded[0...-8]) == decoded[-8..-1]
    end

    def checksum(bytes)
      Digest::SHA256.hexdigest(Digest::SHA256.digest([bytes].pack('H*')))[0...8]
    end
  end
end
