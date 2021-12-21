module AdequateCryptoAddress
  class Ada
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      # if 'Byron era', starts with Icarus-style: 'Ae2' or Daedalus-style: 'DdzFF'
      # if 'Shelley era', starts with 'addr1'
      # https://iohk.zendesk.com/hc/en-us/articles/900005403563-Cardano-address-types
      /\AAe2|DdzFF|addr1/.match?(address_string) ? address_string : 'blah'
      # length check
    end
  end
  Cardano = Ada
end