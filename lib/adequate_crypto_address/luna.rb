module AdequateCryptoAddress
  class Luna
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      /\Aterra/.match?(address_string) ? address_string : 'blah'
      # https://chubk.com/what-is-terra-wallet-luna-instructions-for-creating-and-using-terra-wallet-luna/
      # length check
    end
  end
  Terraluna = Luna
end
