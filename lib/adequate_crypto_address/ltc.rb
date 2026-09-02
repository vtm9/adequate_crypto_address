# frozen_string_literal: true

module AdequateCryptoAddress
  class Ltc < Altcoin
    ADDRESS_TYPES = { prod: %w[30 05 32], test: %w[6f c4 3a] }.freeze

    private

    def address_type
      segwit_decoded = begin
                         decode_segwit_address
                       rescue StandardError
                         nil
                       end

      if segwit_decoded
        witness_version, witness_program_hex, hrp = segwit_decoded
        witness_program = [witness_program_hex].pack('H*')

        if witness_version == 0
          return :prod if hrp == 'ltc' && [20, 32].include?(witness_program.bytesize)
          return :test if hrp == 'tltc' && [20, 32].include?(witness_program.bytesize)
        end

        if witness_version == 1 && witness_program.bytesize == 32
          return :prod if hrp == 'ltc'
          return :test if hrp == 'tltc'
        end
      end

      super
    end

    def decode_segwit_address
      actual_hrp, data, encoding = Utils::Bech32.decode(address, include_encoding: true)

      return nil if actual_hrp.nil?

      length = data.size
      return nil if length == 0 || length > 65
      return nil unless %w[ltc tltc].include?(actual_hrp)
      return nil if data[0] > 16
      return nil if data[0].zero? && encoding != :bech32
      return nil if data[0].positive? && encoding != :bech32m

      program = Utils::Bech32.convert_bits(data[1..-1], from_bits: 5, to_bits: 8, pad: false)
      return nil if program.nil?

      length = program.size
      return nil if length < 2 || length > 40
      return nil if data[0] == 0 && length != 20 && length != 32
      return nil if data[0] == 1 && length != 32

      program_hex = program.pack('C*').unpack('H*').first
      [data[0], program_hex, actual_hrp]
    end
  end
  Litecoin = Ltc
end
