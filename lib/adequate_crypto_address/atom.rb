# frozen_string_literal: true

module AdequateCryptoAddress
  # Cosmos Hub (ATOM) account addresses are Bech32 (not Bech32m) with the
  # `cosmos` human-readable part and a 20-byte address payload.
  # https://docs.cosmos.network/main/build/spec/addresses/bech32
  class Atom
    HRP = 'cosmos'
    PAYLOAD_BYTES = 20
    MAX_LENGTH = 90

    attr_reader :address, :type

    def initialize(address)
      @address = address
      @type = detect_type
    end

    def valid?(validated_type = nil)
      return !type.nil? unless validated_type

      type == validated_type.to_sym
    end

    # :prod when the address is a valid cosmos account address, otherwise nil.
    def address_type
      type
    end

    private

    def detect_type
      return nil if address.to_s.length > MAX_LENGTH

      :prod if valid_bech32?
    end

    def valid_bech32?
      decoded = Utils::Bech32.decode(address, include_encoding: true)
      return false unless decoded

      hrp, data, encoding = decoded
      return false unless hrp == HRP && encoding == :bech32

      bytes = Utils::Bech32.convert_bits(data, from_bits: 5, to_bits: 8, pad: false)
      bytes&.length == PAYLOAD_BYTES
    rescue StandardError
      false
    end
  end

  Cosmos = Atom
end
