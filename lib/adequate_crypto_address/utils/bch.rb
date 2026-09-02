# frozen_string_literal: true

module AdequateCryptoAddress
  module Utils
    module Bch
      CHARSET = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l'

      module_function

      def code_list_to_string(code_list)
        code_list.map { |i| Array(i).pack('C*') }.join
      end

      def b32decode(inputs)
        out = []
        return out unless inputs

        inputs.chars.each do |letter|
          out.push(CHARSET.index(letter))
        end
        out
      end

      def polymod(values)
        chk = 1
        generator = [
          [0x01, 0x98f2bc8e61],
          [0x02, 0x79b76d99e2],
          [0x04, 0xf33e5fb3c4],
          [0x08, 0xae2eabe2a8],
          [0x10, 0x1e4f43e470]
        ]
        values.each do |value|
          top = chk >> 35
          chk = ((chk & 0x07ffffffff) << 5) ^ value
          generator.each do |i|
            chk ^= i[1] if top.anybits?(i[0])
          end
        end
        chk ^ 1
      end

      def expanded_prefix
        val = if prefix
                prefix.to_s.chars.map do |i|
                  i.ord & 0x1f
                end
              else
                []
              end

        val + [0]
      end

      def calculate_cash_checksum(payload)
        poly = polymod(expanded_prefix + payload + [0, 0, 0, 0, 0, 0, 0, 0])
        out = []
        8.times do |i|
          out.push((poly >> (5 * (7 - i))) & 0x1f)
        end
        out
      end

      def verify_cash_checksum(payload)
        polymod(expanded_prefix + payload).zero?
      rescue TypeError
        raise AdequateCryptoAddress::InvalidAddress
      end

      def b32encode(inputs)
        out = ''
        inputs.each do |char_code|
          out += CHARSET[char_code].to_s
        end
        out
      end

      def convertbits(data, frombits, tobits, pad: true)
        Bech32.convert_bits(data, from_bits: frombits, to_bits: tobits, pad: pad)
      end
    end
  end
end
