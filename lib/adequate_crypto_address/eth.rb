# frozen_string_literal: true

module AdequateCryptoAddress
  class Eth
    attr_reader :address, :raw_address

    def initialize(address_sring)
      @address = normalize(address_sring)
      @raw_address = address_sring
    end

    def normalize(address_sring)
      /\A0x/.match?(address_sring) ? address_sring : "0x#{address_sring}"
    end

    def valid?(_type = nil)
      if !valid_format?
        false
      elsif not_checksummed?
        true
      else
        checksum_matches?
      end
    end

    def address_type; end

    private

    def checksummed
      raise "Invalid address: #{address}" unless valid_format?

      cased = unprefixed.chars.zip(checksum.chars).map do |char, check|
        /[0-7]/.match?(check) ? char.downcase : char.upcase
      end

      normalize(cased.join)
    end

    private

    def checksum_matches?
      address == checksummed
    end

    def not_checksummed?
      all_uppercase? || all_lowercase?
    end

    def all_uppercase?
      address.match(/(?:0[xX])[A-F0-9]{40}/)
    end

    def all_lowercase?
      address.match(/(?:0[xX])[a-f0-9]{40}/)
    end

    def valid_format?
      address.match(/\A(?:0[xX])[a-fA-F0-9]{40}\z/)
    end

    def checksum
      bin_to_hex(keccak256(unprefixed.downcase))
    end

    def unprefixed
      remove_hex_prefix address
    end

    def remove_hex_prefix(s)
      s[0, 2] == '0x' ? s[2..-1] : s
    end

    def bin_to_hex(string)
      string.unpack1('H*')
    end

    def keccak256(x)
      Digest::Keccak.new(256).digest(x)
    end
  end
  Ethereum = Eth
end
