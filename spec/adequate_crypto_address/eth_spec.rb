module AdequateCryptoAddress
  class ETH
    describe ETH do
      describe '#valid?' do
        it 'validates etherum address' do
          address = ETH.new('0xab7c74abc0c4d48d1bdad5dcb26153fc8780f83e')

          expect(address.valid?).to be_truthy
        end
      end
    end
  end
end
