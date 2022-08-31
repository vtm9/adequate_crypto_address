# frozen_string_literal: true

module AdequateCryptoAddress
  class Monero
    attr_reader :address, :type

    def initialize(address)
      @address = address
      @type = address_type
    end

    def valid?(type = nil)
      if type
        address_type == type.to_sym
      else
        !address_type.nil?
      end
    end

    private

    def address_type
      return nil unless [95, 106].include?(address.size)

      return :monero if pattern_valid?
    end

    def pattern_valid?
      address.size == 95 ?
        address.match(/^4[0-9AB][1-9A-HJ-NP-Za-km-z]{93}$/) :
        address.match(/^4[1-9A-HJ-NP-Za-km-z]{105}(?:[1-9A-HJ-NP-Za-km-z]{30})?$/)
    end
  end
end
