module AdequateCryptoAddress
  class Dai < Eth
    attr_reader :address, :raw_address

    def initialize(address_string)
      @address = normalize(address_string)
      @raw_address = address_string
    end
    # TODO
    def normalize(address_string)
      /\Asomething/.match?(address_string) ? address_string : 'blah'
      # https://hedera.com/blog/carbon-launches-the-first-stablecoin-on-hedera
      # https://docs.hedera.com/guides/core-concepts/keys-and-signatures ?
      # length check
    end
  end
  DAI = Dai
end

