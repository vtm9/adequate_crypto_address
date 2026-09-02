# frozen_string_literal: true

module AdequateCryptoAddress
  class Btc
    BASE58_TYPES = {
      '00' => :hash160,
      '05' => :p2sh,
      '6f' => :hash160test,
      'c4' => :p2shtest
    }.freeze
    BASE58_NETWORKS = { '00' => :mainnet, '05' => :mainnet, '6f' => :testnet, 'c4' => :testnet }.freeze
    SEGWIT_NETWORKS = { 'bc' => :mainnet, 'tb' => :testnet }.freeze
    MAX_LENGTH = 100

    attr_reader :address, :type, :network
    alias raw_address address

    def initialize(address)
      @address = address
      @type = detect_type
    end

    def valid?(validated_type = nil)
      return !type.nil? unless validated_type

      type == validated_type.to_sym
    end

    # Public contract: the detected type Symbol, or nil when invalid. The
    # SegWit type is network-agnostic; use #network to enforce mainnet/testnet.
    def address_type
      type
    end

    private

    def detect_type
      return nil if address.to_s.length > MAX_LENGTH

      segwit_address_type || base58_address_type
    end

    def segwit_address_type
      hrp, witness_version, witness_program_hex = safely_decode_segwit_address
      return unless witness_version

      witness_program_size = witness_program_hex.length / 2
      type = segwit_type(witness_version, witness_program_size)
      @network = SEGWIT_NETWORKS[hrp] if type
      type
    end

    def segwit_type(witness_version, witness_program_size)
      return { 20 => :segwit_v0_keyhash, 32 => :segwit_v0_scripthash }[witness_program_size] if witness_version.zero?

      :taproot if witness_version == 1 && witness_program_size == 32
    end

    def base58_address_type
      decoded = safely_decode_base58
      return unless decoded&.bytesize == 50
      return unless valid_base58_address_checksum?(decoded)

      version = decoded[0...2]
      @network = BASE58_NETWORKS[version]
      BASE58_TYPES[version]
    end

    def decode_segwit_address
      actual_hrp, data, encoding = Utils::Bech32.decode(address, include_encoding: true)
      return nil unless %w[bc tb].include?(actual_hrp)
      return nil if data.empty? || data.size > 65

      witness_version = data.first
      return nil unless valid_witness_encoding?(witness_version, encoding)

      program = Utils::Bech32.convert_bits(data[1..], from_bits: 5, to_bits: 8, pad: false)
      return nil unless valid_witness_program?(witness_version, program)

      [actual_hrp, witness_version, program.pack('C*').unpack1('H*')]
    end

    def valid_witness_encoding?(witness_version, encoding)
      return false unless witness_version&.between?(0, 16)

      encoding == (witness_version.zero? ? :bech32 : :bech32m)
    end

    def valid_witness_program?(witness_version, program)
      return false unless program&.size&.between?(2, 40)
      return [20, 32].include?(program.size) if witness_version.zero?
      return program.size == 32 if witness_version == 1

      true
    end

    def safely_decode_segwit_address
      decode_segwit_address
    rescue StandardError
      []
    end

    def safely_decode_base58
      decode_base58
    rescue StandardError
      nil
    end

    def decode_base58
      Base58.base58_to_binary(address, :bitcoin).each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
    end

    def valid_base58_address_checksum?(base58_decoded)
      return false unless base58_decoded

      checksum(base58_decoded[0...-8]) == base58_decoded[-8..]
    end

    def checksum(hex)
      Digest::SHA256.hexdigest(Digest::SHA256.digest([hex].pack('H*')))[0...8]
    end
  end

  Bitcoin = Btc
end
