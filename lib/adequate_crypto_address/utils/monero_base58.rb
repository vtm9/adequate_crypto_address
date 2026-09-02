# frozen_string_literal: true

module AdequateCryptoAddress
  module Utils
    # Monero's Base58 encodes fixed 8-byte blocks into 11 characters (shorter
    # trailing blocks use fewer characters). Reference:
    # https://github.com/monero-project/monero/blob/master/src/common/base58.cpp
    module MoneroBase58
      ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
      FULL_BLOCK_SIZE = 8
      FULL_ENCODED_BLOCK_SIZE = 11
      # Decoded byte count produced by an encoded block of each valid length.
      ENCODED_BLOCK_SIZES = [0, 2, 3, 5, 6, 7, 9, 10, 11].freeze

      module_function

      def decode(string)
        return nil if string.nil? || string.empty?

        full_blocks = string.length / FULL_ENCODED_BLOCK_SIZE
        last_size = string.length % FULL_ENCODED_BLOCK_SIZE
        return nil unless ENCODED_BLOCK_SIZES.include?(last_size)

        out = []
        full_blocks.times do |i|
          block = decode_block(string[i * FULL_ENCODED_BLOCK_SIZE, FULL_ENCODED_BLOCK_SIZE], FULL_BLOCK_SIZE)
          return nil unless block

          out.concat(block)
        end
        decode_tail(string, full_blocks, last_size, out)
      end

      def decode_tail(string, full_blocks, last_size, out)
        return out if last_size.zero?

        tail = string[full_blocks * FULL_ENCODED_BLOCK_SIZE, last_size]
        block = decode_block(tail, ENCODED_BLOCK_SIZES.index(last_size))
        return nil unless block

        out.concat(block)
      end

      # Decodes one Base58 block into exactly `size` big-endian bytes, rejecting
      # unknown characters and values that overflow the target byte width.
      def decode_block(chars, size)
        num = 0
        chars.each_char do |char|
          index = ALPHABET.index(char)
          return nil unless index

          num = (num * 58) + index
        end
        return nil if num >= (1 << (size * 8))

        Array.new(size) { |i| (num >> (8 * (size - 1 - i))) & 0xff }
      end
    end
  end
end
