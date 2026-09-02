# frozen_string_literal: true

module AdequateCryptoAddress
  class Ltc < Altcoin
    ADDRESS_TYPES = { prod: %w[30 05 32], test: %w[6f c4 3a] }.freeze

    private

    def detect_type
      return nil if too_long?

      segwit_address_type || super
    end

    def segwit_address_type
      witness_version, witness_program_hex, hrp = safely_decode_segwit_address
      return unless witness_version

      witness_program_size = witness_program_hex.length / 2
      return unless valid_known_witness_program?(witness_version, witness_program_size)

      { 'ltc' => :prod, 'tltc' => :test }[hrp]
    end

    def decode_segwit_address
      actual_hrp, data, encoding = Utils::Bech32.decode(address, include_encoding: true)
      return nil unless %w[ltc tltc].include?(actual_hrp)
      return nil if data.empty? || data.size > 65

      witness_version = data.first
      return nil unless valid_witness_encoding?(witness_version, encoding)

      program = Utils::Bech32.convert_bits(data[1..], from_bits: 5, to_bits: 8, pad: false)
      return nil unless valid_witness_program?(witness_version, program)

      program_hex = program.pack('C*').unpack1('H*')
      [witness_version, program_hex, actual_hrp]
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

    def valid_known_witness_program?(witness_version, program_size)
      (witness_version.zero? && [20, 32].include?(program_size)) || (witness_version == 1 && program_size == 32)
    end

    def safely_decode_segwit_address
      decode_segwit_address
    rescue StandardError
      []
    end
  end
  Litecoin = Ltc
end
