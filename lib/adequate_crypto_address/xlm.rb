# frozen_string_literal: true

module AdequateCryptoAddress
  class Xlm
    attr_reader :address

    ACCOUNT_VERSION_BYTE = 0x30
    MUXED_VERSION_BYTE = 0x60

    ACCOUNT_SIZE = 35
    MUXED_SIZE = 43

    def initialize(address)
      @address = address
    end

    def valid?(_type = nil)
      valid_address?
    end

    def address_type; end

    private

    def valid_address?
      decoded = decode_strkey

      return false unless decoded

      version = decoded.getbyte(0)

      case version
      when ACCOUNT_VERSION_BYTE
        valid_strkey?(decoded, ACCOUNT_SIZE)

      when MUXED_VERSION_BYTE
        valid_strkey?(decoded, MUXED_SIZE)

      else
        false
      end
    rescue StandardError
      false
    end

    def valid_strkey?(decoded, expected_size)
      return false unless decoded.bytesize == expected_size

      payload = decoded[0...-2]
      checksum = decoded[-2..]

      crc16(payload) == checksum
    end

    def decode_strkey
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
