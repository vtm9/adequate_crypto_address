module AdequateCryptoAddress
  class ETH
    describe ETH do
      describe '#valid?' do
        it 'validates correct etherum address' do
          address = ETH.new('0xab7c74abc0c4d48d1bdad5dcb26153fc8780f83e')

          expect(address.valid?).to be_truthy
        end

        it 'validates wrong check sum in etherum address' do
          address = ETH.new('0xab7c74abc0c4d48d1bdad5dcb26153fr8780f83e')

          expect(address.valid?).to be_falsey
        end

        it 'validates wrong etherum address' do
          address = ETH.new('0xab7c74abc0c4d48d1bda')

          expect(address.valid?).to be_falsey
        end
      end
    end
  end
end
