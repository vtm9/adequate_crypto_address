# frozen_string_literal: true

module AdequateCryptoAddress
  class Xlm
    attr_reader :address

    ACCOUNT_VERSION_BYTE = 0x30
    MUXED_VERSION_BYTE = 0x60

    ACCOUNT_SIZE = 35
    MUXED_SIZE = 43
    MAX_LENGTH = 90 # G-addresses are 56 chars, M-addresses 69

    def initialize(address)
      @address = address
    end

    def valid?(_type = nil)
      !address_type.nil?
    end

    # :account (G...) or :muxed (M...) when valid, otherwise nil.
    def address_type
      decoded = decode_strkey
      return nil unless decoded

      case decoded.getbyte(0)
      when ACCOUNT_VERSION_BYTE
        :account if valid_strkey?(decoded, ACCOUNT_SIZE)
      when MUXED_VERSION_BYTE
        :muxed if valid_strkey?(decoded, MUXED_SIZE)
      end
    rescue StandardError
      nil
    end

    private

    def valid_strkey?(decoded, expected_size)
      return false unless decoded.bytesize == expected_size

      payload = decoded[0...-2]
      checksum = decoded[-2..]

      crc16(payload) == checksum
    end

    def decode_strkey
      return nil if address.to_s.length > MAX_LENGTH

      Utils::Xlm.decode(address)
    end

    def crc16(data)
      crc = 0

      data.each_byte do |byte|
        crc ^= byte << 8

        8.times do
          crc =
            if crc.anybits?(0x8000)
              (crc << 1) ^ 0x1021
            else
              crc << 1
            end
        end
      end

      [crc & 0xffff].pack('v')
    end
  end

  Stellar = Xlm
end
