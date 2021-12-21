module AdequateCryptoAddress
  class Ltc
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      /\AL|M|ltc1/.match?(address_string) ? address_string : 'blah'
      # https://coin.space/all-about-address-types/
      # length check
    end
  end
  Litecoin = Ltc
end
