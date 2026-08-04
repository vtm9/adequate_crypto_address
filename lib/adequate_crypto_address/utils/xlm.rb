# frozen_string_literal: true

module AdequateCryptoAddress
  module Utils
    module Xlm
      CHARSET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'

      module_function

      def decode(input)
        values = input.chars.map { |c| CHARSET.index(c) }
        return nil if values.include?(nil)

        bytes = convertbits(values, 5, 8, false)
        return nil unless bytes

        bytes.pack('C*')
      end

      def convertbits(data, frombits, tobits, pad = true)
        acc = 0
        bits = 0
        ret = []
        maxv = (1 << tobits) - 1

        data.each do |value|
          return nil if value < 0 || (value >> frombits) != 0

          acc = (acc << frombits) | value
          bits += frombits

          while bits >= tobits
            bits -= tobits
            ret << ((acc >> bits) & maxv)
          end
        end

        if pad
          ret << ((acc << (tobits - bits)) & maxv) if bits > 0
        else
          return nil if bits >= frombits
          return nil if ((acc << (tobits - bits)) & maxv) != 0
        end

        ret
      end
    end
  end
end
