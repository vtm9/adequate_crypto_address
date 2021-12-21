module AdequateCryptoAddress
  module Stablecoins
    class Ust
      attr_reader :address, :raw_address

      def initialize(address_string)
        @address = normalize(address_string)
        @raw_address = address_string
      end

      def normalize(address_string)
        /\Aterra1/.match?(address_string) ? address_string : 'blah'
        # length check
      end
    end
    TerraUSD = Ust
  end
end
