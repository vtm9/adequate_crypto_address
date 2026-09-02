# frozen_string_literal: true

module AdequateCryptoAddress
  module Utils
    module Xlm
      CHARSET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'

      module_function

      def decode(input)
        values = input.chars.map { |c| CHARSET.index(c) }
        return nil if values.include?(nil)

        bytes = convertbits(values, 5, 8, pad: false)
        return nil unless bytes

        bytes.pack('C*')
      end

      def convertbits(data, frombits, tobits, pad: true)
        Bech32.convert_bits(data, from_bits: frombits, to_bits: tobits, pad: pad)
      end
    end
  end
end
