RSpec.describe(AdequateCryptoAddress) do
  describe '.valid?' do
    context 'Bitcoin' do
      it 'validates hash160 addresses' do
        expect(described_class).to be_valid('12KYrjTdVGjFMtaxERSk3gphreJ5US8aUP', 'bitcoin')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'BTC')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'Bitcoin')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'btc')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'btc', :hash160)
      end

      it 'validates p2sh addresses' do
        expect(described_class).to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'BTC')
        expect(described_class).to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'bitcoin', 'p2sh')
      end

      it 'validates segwit addresses' do
        expect(described_class).to be_valid('BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4', 'BTC')
        expect(described_class).to be_valid('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq', 'bitcoin')
        expect(described_class).to be_valid('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq', 'bitcoin', 'segwit_v0_keyhash')
        expect(described_class).to be_valid('bc1qc7slrfxkknqcq2jevvvkdgvrt8080852dfjewde450xdlk4ugp7szw5tk9', 'BTC')
        expect(described_class).to be_valid('bc1qc7slrfxkknqcq2jevvvkdgvrt8080852dfjewde450xdlk4ugp7szw5tk9', 'bitcoin', 'segwit_v0_scripthash')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('asdf', :bitcoin)
        expect(described_class).not_to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'bitcoin', :segwit_v0_keyhash)
        expect(described_class).not_to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'bitcoin', 'asdf')
        expect(described_class).not_to be_valid('tc1qw508d6qejxtdg4y5r3zarvary0c5xw7kg3g4ty', :bitcoin)
        expect(described_class).not_to be_valid('bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t5', 'bitcoin')
        expect(described_class).not_to be_valid('BC13W508D6QEJXTDG4Y5R3ZARVARY0C5XW7KN40WF2', 'bitcoin')
        expect(described_class).not_to be_valid('bc1rw5uspcuh', 'bitcoin')
        expect(described_class).not_to be_valid('bc10w508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kw5rljs90', 'bitcoin')
        expect(described_class).not_to be_valid('BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P', 'bitcoin')
        expect(described_class).not_to be_valid('tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sL5k7', 'BTC')
        expect(described_class).not_to be_valid('bc1zw508d6qejxtdg4y5r3zarvaryvqyzf3du', 'bitcoin')
        expect(described_class).not_to be_valid('tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3pjxtptv', 'Bitcoin')
        expect(described_class).not_to be_valid('bc1gmk9yu', 'bitcoin')
      end
    end

    context 'Bitcoincash' do
      it 'validates legacy addresses' do
        expect(described_class).to be_valid('3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTzC', :bch, :P2SH)
        expect(described_class).to be_valid('155fzsEBHy9Ri2bMQ8uuuR3tv1YzcDywd4', 'bitcoincash', :P2PKH)
        expect(described_class).to be_valid('2MzQwSSnBHWHqSAqtTVQ6v47XtaisrJa1Vc', 'BCH', :P2SHTestnet)
        expect(described_class).to be_valid('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD', :BCH, :P2PKHTestnet)
      end

      it 'validates cash addresses' do
        expect(described_class).to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h', :bch, :P2PKH)
        expect(described_class).to be_valid('bitcoincash:pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash, :P2SH)
        expect(described_class).to be_valid('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf', :Bitcoincash, :P2PKHTestnet)
        expect(described_class).to be_valid('bchtest:pp8f7ww2g6y07ypp9r4yendrgyznysc9kqxh6acwu3', :BCH, :P2SHTestnet)
        expect(described_class).to be_valid('bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', :bitcoincash)
      end

      it 'validates cash addresses without prefix addresses' do
        expect(described_class).to be_valid('qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', :bitcoincash)
        expect(described_class).to be_valid('pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash, :P2SH)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxP635va4h86wv435995w8p2H', :bch)
        expect(described_class).not_to be_valid('wrong', :bch)
        expect(described_class).not_to be_valid('bitcoincash:wrong', :bch)
        expect(described_class).not_to be_valid('bitcoincash:123', :bch)

        expect(described_class).not_to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h', :bch, :P2PKHTestnet)
        expect(described_class).not_to be_valid('bitcoincash:pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash, :P2PKHTestnet)
        expect(described_class).not_to be_valid('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf', :Bitcoincash, :P2SH)
        expect(described_class).not_to be_valid('bchtest:pp8f7ww2g6y07ypp9r4yendrgyznysc9kqxh6acwu3', :BCH, :P2SH)
      end
    end

    context 'Ethereum' do
      it 'validates addresses' do
        expect(described_class).to be_valid('0xE37c0D48d68da5c5b14E5c1a9f1CFE802776D9FF', 'ethereum')
        expect(described_class).to be_valid('0xa00354276d2fC74ee91e37D085d35748613f4748', :ethereum)
        expect(described_class).to be_valid('0xAff4d6793F584a473348EbA058deb8caad77a288', :ETH)
        expect(described_class).to be_valid('0xc6d9d2cd449a754c494264e1809c50e34d64562b', 'ETH')
        expect(described_class).to be_valid('0x52908400098527886E0F7030069857D2E4169EE7', 'ETH')
        expect(described_class).to be_valid('0x8617E340B3D01FA5F11F306F4090FD50E238070D', 'ETH')
        expect(described_class).to be_valid('0xde709f2102306220921060314715629080e2fb77', 'ETH')
        expect(described_class).to be_valid('0x27b1fdb04752bbc536007a920d24acb045561c26', 'ETH')
        expect(described_class).to be_valid('0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed', 'ETH')
        expect(described_class).to be_valid('0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359', 'ETH')
        expect(described_class).to be_valid('0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB', 'ETH')
        expect(described_class).to be_valid('0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'ETH')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('0xD1110A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'ETH')
        expect(described_class).not_to be_valid('0xa10354276d2fC74ee91e37D085d35748613f4748', :ethereum)
      end
    end
  end
end
