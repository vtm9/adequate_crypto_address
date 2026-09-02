# frozen_string_literal: true

module AdequateCryptoAddress
  class Btc
    BASE58_TYPES = {
      '00' => :hash160,
      '05' => :p2sh,
      '6f' => :hash160test,
      'c4' => :p2shtest
    }.freeze

    attr_reader :address, :type
    alias raw_address address

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

    private

    def address_type
      segwit_address_type || base58_address_type
    end

    def segwit_address_type
      witness_version, witness_program_hex = safely_decode_segwit_address
      return unless witness_version

      witness_program_size = witness_program_hex.length / 2
      return { 20 => :segwit_v0_keyhash, 32 => :segwit_v0_scripthash }[witness_program_size] if witness_version.zero?

      :taproot if witness_version == 1 && witness_program_size == 32
    end

    def base58_address_type
      decoded = safely_decode_base58
      return unless decoded&.bytesize == 50
      return unless valid_base58_address_checksum?(decoded)

      BASE58_TYPES[decoded[0...2]]
    end

    def decode_segwit_address
      actual_hrp, data, encoding = Utils::Bech32.decode(address, include_encoding: true)
      return nil unless %w[bc tb].include?(actual_hrp)
      return nil if data.empty? || data.size > 65

      witness_version = data.first
      return nil unless valid_witness_encoding?(witness_version, encoding)

      program = Utils::Bech32.convert_bits(data[1..], from_bits: 5, to_bits: 8, pad: false)
      return nil unless valid_witness_program?(witness_version, program)

      program_hex = program.pack('C*').unpack1('H*')
      [witness_version, program_hex]
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
