module AdequateCryptoAddress
  class Eos
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      # not too sure about this one
      /(?i)^[a-z1-5]$/.match?(address_string) ? address_string : 'blah'
      # https://github.com/EOSIO/eosjs-ecc
      # length check
    end
  end
  EOS = Eos
end
