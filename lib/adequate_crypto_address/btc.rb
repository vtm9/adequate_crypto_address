# frozen_string_literal: true

module AdequateCryptoAddress
  class Btc
    attr_reader :address
    alias raw_address address

    def initialize(address)
      @address = address
    end

    def valid?(type = nil)
      if type
        address_type == type.to_sym
      else
        !address_type.nil?
      end
    end

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

      hex = begin
              decode_base58(address)
            rescue StandardError
              nil
            end
      if hex && hex.bytesize == 50 && address_checksum?
        case hex[0...2]
        when '00'
          return :hash160
        when '05'
          return :p2sh
        end
      end

      nil
    end

    private

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

    def decode_base58(base58_val)
      s = Base58.base58_to_int(address, :bitcoin).to_s(16); s = (s.bytesize.odd? ? '0' + s : s)
      s = '' if s == '00'
      leading_zero_bytes = (base58_val =~ /^([1]+)/ ? Regexp.last_match(1) : '').size
      s = ('00' * leading_zero_bytes) + s if leading_zero_bytes > 0
      s
    end

    def address_checksum?
      hex = begin
              decode_base58(address)
            rescue StandardError
              nil
            end
      return false unless hex

      checksum(hex[0...42]) == hex[-8..-1]
    end

    # checksum is a 4 bytes sha256-sha256 hexdigest.
    def checksum(hex)
      b = [hex].pack('H*') # unpack hex
      Digest::SHA256.hexdigest(Digest::SHA256.digest(b))[0...8]
    end
  end
  Bitcoin = Btc
end
