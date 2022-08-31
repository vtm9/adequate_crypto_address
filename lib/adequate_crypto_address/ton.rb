# frozen_string_literal: true

module AdequateCryptoAddress
  class Ton
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
      return :TON if address.size == 48 && pattern_valid?
    end

    def pattern_valid?
      address.match(/([0-9a-zA-Z]|-|_){48}/)
    end
  end
end
