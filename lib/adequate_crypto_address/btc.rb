# frozen_string_literal: true

module AdequateCryptoAddress
  class Btc
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
      segwit_decoded = begin
                         decode_segwit_address
                       rescue StandardError
                         nil
                       end
      if segwit_decoded
        witness_version, witness_program_hex = segwit_decoded
        witness_program = [witness_program_hex].pack('H*')

        return :segwit_v0_keyhash if witness_version == 0 && witness_program.bytesize == 20

        return :segwit_v0_scripthash if witness_version == 0 && witness_program.bytesize == 32
      end

      base58_decoded = begin
              decode_base58(address)
                       rescue StandardError
                         nil
            end
      if base58_decoded && base58_decoded.bytesize == 50 && valid_base58_address_checksum?(base58_decoded)
        case base58_decoded[0...2]
        when '00'
          return :hash160
        when '05'
          return :p2sh
        when '6f'
          return :hash160test
        when 'c4'
          return :p2shtest
        end
      end

      nil
    end

    def decode_segwit_address
      actual_hrp, data = Utils::Bech32.decode(address)

      return nil if actual_hrp.nil?

      length = data.size
      return nil if length == 0 || length > 65
      return nil if actual_hrp != 'bc'
      return nil if data[0] > 16

      program = Utils::Bech32.convert_bits(data[1..-1], from_bits: 5, to_bits: 8, pad: false)
      return nil if program.nil?

      length = program.size
      return nil if length < 2 || length > 40
      return nil if data[0] == 0 && length != 20 && length != 32

      program_hex = program.pack('C*').unpack('H*').first
      [data[0], program_hex]
    end

    def decode_base58(_base58_val)
      Base58.base58_to_binary(address, :bitcoin).each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
    end

    def valid_base58_address_checksum?(base58_decoded)
      return false unless base58_decoded

      checksum(base58_decoded[0...-8]) == base58_decoded[-8..-1]
    end

    def checksum(hex)
      Digest::SHA256.hexdigest(Digest::SHA256.digest([hex].pack('H*')))[0...8]
    end
  end
  Bitcoin = Btc
end
