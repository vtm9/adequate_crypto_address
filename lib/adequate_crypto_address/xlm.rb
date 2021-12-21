module AdequateCryptoAddress
  class Xlm
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      /\AG/.match?(address_string) ? address_string : 'blah'
      # https://lumenthropy.com/stellar-wallet-address/
      # length check
    end
  end
  Lumens = Xlm
end
