module AdequateCryptoAddress
  module Utils
    module Bch
      CHARSET = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l'.freeze

      module_function

      def code_list_to_string(code_list)
        code_list.map { |i| Array(i).pack('C*') }.flatten.join
      end

      def b32decode(inputs)
        out = []
        return out unless inputs

        inputs.split('').each do |letter|
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
            chk ^= i[1] if (top & i[0]) != 0
          end
        end
        chk ^ 1
      end

      def expanded_prefix
        val = if prefix
                prefix.to_s.split('').map do |i|
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
          out.push((poly >> 5 * (7 - i)) & 0x1f)
        end
        out
      end

      def verify_cash_checksum(payload)
        polymod(expanded_prefix + payload) == 0
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

      def convertbits(data, frombits, tobits, pad = true)
        acc = 0
        bits = 0
        ret = []
        maxv = (1 << tobits) - 1
        max_acc = (1 << (frombits + tobits - 1)) - 1
        data.each do |value|
          return nil if value < 0 || ((value >> frombits) != 0)

          acc = ((acc << frombits) | value) & max_acc
          bits += frombits
          while bits >= tobits
            bits -= tobits
            ret.push((acc >> bits) & maxv)
          end
        end
        if pad
          ret.push((acc << (tobits - bits)) & maxv) if bits != 0
        elsif bits >= frombits || (((acc << (tobits - bits)) & maxv) != 0)
          return nil
        end
        ret
      end
    end
  end
end
