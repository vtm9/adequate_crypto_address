module AdequateCryptoAddress
  class Dot
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end

    def normalize(address_string)
      /\A1/.match?(address_string) ? address_string : 'blah'
      # https://wiki.polkadot.network/docs/learn-accounts
      # length check
    end
  end
  Polkadot = Dot
end
