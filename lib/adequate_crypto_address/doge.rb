module AdequateCryptoAddress
  class Doge
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      # must begin with 'D'
      # must precede with a capital letter or number
      /\AD+[A-Z0-9]/.match?(address_string) ? address_string : 'blah'
      # length check
    end
  end
  Dogecoin = Doge
end
