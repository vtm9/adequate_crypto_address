module AdequateCryptoAddress
  class Bsv
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      # must begin with either the letter "q" or "p"
      /\Aa|q/.match?(address_string) ? address_string : 'blah'
      # but what if it's old legacy format?
      # length check
    end
  end
  BitcoinSV = BSV
end