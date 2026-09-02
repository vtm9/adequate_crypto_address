# frozen_string_literal: true

module AdequateCryptoAddress
  # Ruby reference implementation: https://github.com/sipa/bech32/tree/master/ref/c
  module Utils
    module Bech32
      CHARSET = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l'.unpack('C*')
      CHARSET_REV = [
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        15, -1, 10, 17, 21, 20, 26, 30, 7, 5, -1, -1, -1, -1, -1, -1,
        -1, 29, -1, 24, 13, 25, 9, 8, 23, -1, 18, 22, 31, 27, 19, -1,
        1,  0,  3, 16, 11, 28, 12, 14, 6, 4, 2, -1, -1, -1, -1, -1,
        -1, 29, -1, 24, 13, 25, 9, 8, 23, -1, 18, 22, 31, 27, 19, -1,
        1,  0,  3, 16, 11, 28, 12, 14, 6, 4, 2, -1, -1, -1, -1, -1
      ].freeze
      GENERATORS = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3].freeze

      class << self
        def polymod_step(pre)
          b = pre >> 25
          GENERATORS.each_with_index.reduce((pre & 0x1FFFFFF) << 5) do |checksum, (generator, index)|
            checksum ^ (-((b >> index) & 1) & generator)
          end
        end

        def decode(input, ignore_length: false, include_encoding: false)
          hrp_string, data_string = split_input(input, ignore_length: ignore_length)
          return nil unless hrp_string

          hrp, checksum, casing = decode_hrp(hrp_string)
          return nil unless hrp

          data, checksum, casing = decode_data(data_string, checksum, casing)
          return nil unless data
          return nil if casing.values.all?

          encoding = checksum_encoding(checksum)
          return nil unless encoding

          decoded = [hrp.pack('C*'), data]
          include_encoding ? decoded << encoding : decoded
        end

        # Utility for converting bytes of data between bases. These is used for
        # BIP 173 address encoding/decoding to convert between sequences of bytes
        # representing 8-bit values and groups of 5 bits. Conversions may be padded
        # with trailing 0 bits to the nearest byte boundary. Returns nil if
        # conversion requires padding and pad is false.
        #
        # For example:
        #
        #   convert_bits("\xFF\xFF", from_bits: 8, to_bits: 5, pad: true)
        #     => "\x1F\x1F\x1F\10"
        #
        # See https://github.com/bitcoin/bitcoin/blob/595a7bab23bc21049526229054ea1fff1a29c0bf/src/utilstrencodings.h#L154
        def convert_bits(chunks, from_bits:, to_bits:, pad:)
          return nil unless valid_chunks?(chunks, from_bits)

          conversion = {
            from_bits: from_bits,
            to_bits: to_bits,
            output_mask: (1 << to_bits) - 1,
            buffer_mask: (1 << (from_bits + to_bits - 1)) - 1
          }
          buffer = 0
          bits = 0
          output = []

          chunks.each do |chunk|
            buffer, bits, converted = convert_chunk(chunk, buffer, bits, conversion)
            output.concat(converted)
          end

          remainder = conversion_remainder(buffer, bits, conversion, pad)
          return nil if remainder == :invalid

          output << remainder if remainder

          output
        end

        private

        def split_input(input, ignore_length:)
          input_length = input.bytesize
          return if input_length < 8
          return if input_length > 90 && !ignore_length

          separator = input.rindex('1')
          return unless separator&.positive?
          return if (input_length - separator - 1) < 6

          [input[0...separator], input[(separator + 1)..]]
        end

        def decode_hrp(hrp_string)
          hrp, casing = normalize_hrp(hrp_string)
          return unless hrp

          [hrp, hrp_checksum(hrp), casing]
        end

        def normalize_hrp(hrp_string)
          hrp = []
          casing = { lower: false, upper: false }

          index = 0
          while index < hrp_string.bytesize
            character = hrp_string.getbyte(index)
            character, character_case = normalize_hrp_character(character)
            return unless character

            casing[character_case] = true if character_case
            hrp << character
            index += 1
          end

          [hrp, casing]
        end

        def hrp_checksum(hrp)
          checksum = hrp.reduce(1) do |value, character|
            polymod_step(value) ^ (character >> 5)
          end
          checksum = polymod_step(checksum)
          hrp.each { |character| checksum = polymod_step(checksum) ^ (character & 0x1f) }
          checksum
        end

        def decode_data(data_string, checksum, casing)
          data = []
          payload_length = data_string.bytesize - 6

          index = 0
          while index < data_string.bytesize
            character = data_string.getbyte(index)
            value = character.nobits?(0x80) ? CHARSET_REV[character] : -1
            return if value == -1

            character_case = letter_case(character)
            casing[character_case] = true if character_case
            checksum = polymod_step(checksum) ^ value
            data << value if index < payload_length
            index += 1
          end

          [data, checksum, casing]
        end

        def normalize_hrp_character(character)
          return unless character.between?(33, 126)
          return [character, :lower] if character.between?('a'.ord, 'z'.ord)
          return [(character - 'A'.ord) + 'a'.ord, :upper] if character.between?('A'.ord, 'Z'.ord)

          [character, nil]
        end

        def letter_case(character)
          return :lower if character.between?('a'.ord, 'z'.ord)

          :upper if character.between?('A'.ord, 'Z'.ord)
        end

        def checksum_encoding(checksum)
          return :bech32 if checksum == 1

          :bech32m if checksum == 0x2bc830a3
        end

        def valid_chunks?(chunks, from_bits)
          chunks.all? { |chunk| chunk.between?(0, (1 << from_bits) - 1) }
        end

        def convert_chunk(chunk, buffer, bits, conversion)
          buffer = ((buffer << conversion[:from_bits]) | chunk) & conversion[:buffer_mask]
          bits += conversion[:from_bits]
          output = []

          while bits >= conversion[:to_bits]
            bits -= conversion[:to_bits]
            output << ((buffer >> bits) & conversion[:output_mask])
          end

          [buffer, bits, output]
        end

        def conversion_remainder(buffer, bits, conversion, pad)
          return (buffer << (conversion[:to_bits] - bits)) & conversion[:output_mask] if pad && bits.positive?
          return if pad
          return :invalid if bits >= conversion[:from_bits]

          :invalid if (buffer << (conversion[:to_bits] - bits)).anybits?(conversion[:output_mask])
        end
      end
    end
  end
end
