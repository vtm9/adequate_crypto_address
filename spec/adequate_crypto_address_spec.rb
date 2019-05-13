# frozen_string_literal: true

RSpec.describe(AdequateCryptoAddress) do
  describe '.valid?' do
    context 'Bitcoin' do
      it 'validates hash160 addresses' do
        expect(described_class).to be_valid('12KYrjTdVGjFMtaxERSk3gphreJ5US8aUP', 'bitcoin')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'BTC')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'Bitcoin')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'btc')
        expect(described_class).to be_valid('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'btc', :hash160)

        # testnet
        expect(described_class).to be_valid('mzBc4XEFSdzCDcTxAgf6EZXgsZWpztRhef', 'bitcoin', 'hash160test')
        expect(described_class).to be_valid('mv4rnyY3Su5gjcDNzbMLKBQkBicCtHUtFB', :btc)
      end

      it 'validates p2sh addresses' do
        expect(described_class).to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'BTC')
        expect(described_class).to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'bitcoin', 'p2sh')

        # testnet
        expect(described_class).to be_valid('2MxKEf2su6FGAUfCEAHreGFQvEYrfYNHvL7', 'btc')
        expect(described_class).to be_valid('2MxKEf2su6FGAUfCEAHreGFQvEYrfYNHvL7', 'bitcoin', 'p2shtest')
      end

      it 'validates segwit addresses' do
        expect(described_class).to be_valid('BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4', 'BTC')
        expect(described_class).to be_valid('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq', 'bitcoin')
        expect(described_class).to be_valid('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq', 'bitcoin', :segwit_v0_keyhash)
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
        expect(described_class).to be_valid('3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTzC', :bch, :p2sh)
        expect(described_class).to be_valid('155fzsEBHy9Ri2bMQ8uuuR3tv1YzcDywd4', 'bitcoincash', :p2pkh)
        expect(described_class).to be_valid('2MzQwSSnBHWHqSAqtTVQ6v47XtaisrJa1Vc', 'BCH', :p2shtest)
        expect(described_class).to be_valid('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD', :BCH, :p2pkhtest)
      end

      it 'validates cash addresses' do
        expect(described_class).to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h', :bch, :p2pkh)
        expect(described_class).to be_valid('bitcoincash:pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash, :p2sh)
        expect(described_class).to be_valid('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf', :Bitcoincash, :p2pkhtest)
        expect(described_class).to be_valid('bchtest:pp8f7ww2g6y07ypp9r4yendrgyznysc9kqxh6acwu3', :BCH, :p2shtest)
        expect(described_class).to be_valid('bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', :bitcoincash)
      end

      it 'validates cash addresses without prefix addresses' do
        expect(described_class).to be_valid('qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', :bitcoincash)
        expect(described_class).to be_valid('pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash, :p2sh)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxP635va4h86wv435995w8p2H', :bch)
        expect(described_class).not_to be_valid('wrong', :bch)
        expect(described_class).not_to be_valid('bitcoincash:wrong', :bch)
        expect(described_class).not_to be_valid('bitcoincash:123', :bch)

        expect(described_class).not_to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h', :bch, :p2pkhtest)
        expect(described_class).not_to be_valid('bitcoincash:pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash, :p2pkhtest)
        expect(described_class).not_to be_valid('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf', :Bitcoincash, :p2sh)
        expect(described_class).not_to be_valid('bchtest:pp8f7ww2g6y07ypp9r4yendrgyznysc9kqxh6acwu3', :BCH, :p2sh)
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
      end

      it 'validates without prefixes addresses' do
        expect(described_class).to be_valid('27b1fdb04752bbc536007a920d24acb045561c26', 'ETH')
        expect(described_class).to be_valid('5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed', 'ETH')
        expect(described_class).to be_valid('fB6916095ca1df60bB79Ce92cE3Ea74c37c5d359', 'ETH')
        expect(described_class).to be_valid('dbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB', 'ETH')
        expect(described_class).to be_valid('D1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'ETH')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :ETH)
        expect(described_class).not_to be_valid('0xD1110A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'ETH')
        expect(described_class).not_to be_valid('a10354276d2fC74ee91e37D085d35748613f4748', :ethereum)
      end
    end

    context 'Ripple' do
      it 'validates addresses' do
        expect(described_class).to be_valid('rPMLwSwyyULN2acf5JKB1nj8F8Eu8pVMV8', :ripple)
        expect(described_class).to be_valid('rG1QQv2nh2gr7RCZ1P8YYcBUKCCN633jCn', :ripple)
        expect(described_class).to be_valid('rG1QQv2nh2gr7RCZ1P8YYcBUKCCN633jCn', 'RIPPLE')
        expect(described_class).to be_valid('r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV', 'XRP')
        expect(described_class).to be_valid('rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh', :XRP)
        expect(described_class).to be_valid('rDTXLQ7ZKZVKz33zJbHjgVShjsBnqMBhmN', 'XRP')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :xrp)
        expect(described_class).not_to be_valid('r3kmLJN5D28dHuH8vZNUZpMC43pEHpaoc1', :xrp)
        expect(described_class).not_to be_valid('r1kmLJN5D28dHuH8vZNUZpMC43pEHpaocV', 'ripple')
      end
    end

    context 'Dash' do
      it 'validates addresses' do
        expect(described_class).to be_valid('Xx4dYKgz3Zcv6kheaqog3fynaKWjbahb6b', :dash)
        expect(described_class).to be_valid('XcY4WJ6Z2Q8w7vcYER1JypC8s2oa3SQ1b1', 'DASH')
        expect(described_class).to be_valid('XqMkVUZnqe3w4xvgdZRtZoe7gMitDudGs4', 'DASH', :prod)
        expect(described_class).to be_valid('yPv7h2i8v3dJjfSH4L3x91JSJszjdbsJJA', :DASH, 'test')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :dash)
        expect(described_class).not_to be_valid('yPv7h2i8v3dJ1fSH4L3x91JSJszjdbsJJA', :dash)
        expect(described_class).not_to be_valid('XqMkVUZnqe3w4xvgdZRtZoe7gMitDudGs4', 'dash', :test)
        expect(described_class).not_to be_valid('yPv7h2i8v3dJjfSH4L3x91JSJszjdbsJJA', :DASH, :prod)
      end
    end

    context 'Zcash' do
      it 'validates addresses' do
        expect(described_class).to be_valid('t1U9yhDa5XEjgfnTgZoKddeSiEN1aoLkQxq', :zec)
        expect(described_class).to be_valid('t3Vz22vK5z2LcKEdg16Yv4FFneEL1zg9ojd', 'zcash', :prod)
        expect(described_class).to be_valid('t2UNzUUx8mWBCRYPRezvA363EYXyEpHokyi', 'ZEC', :test)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :zec)
        expect(described_class).not_to be_valid('t1Y9yhDa5XEjgfnTgZoKddeSiEN1aoLkQxq', :zcash)
        expect(described_class).not_to be_valid('t3Yz22vK5z2LcKEdg16Yv4FFneEL1zg9ojd', :ZEC)
        expect(described_class).not_to be_valid('t2YNzUUx8mWBCRYPRezvA363EYXyEpHokyi', :zcash, :test)
      end
    end

    context 'Litecoin' do
      it 'validates addresses' do
        expect(described_class).to be_valid('LVg2kJoFNg45Nbpy53h7Fe1wKyeXVRhMH9', :ltc)
        expect(described_class).to be_valid('LVg2kJoFNg45Nbpy53h7Fe1wKyeXVRhMH9', 'ltc', :prod)
        expect(described_class).to be_valid('LTpYZG19YmfvY2bBDYtCKpunVRw7nVgRHW', 'LTC')
        expect(described_class).to be_valid('Lb6wDP2kHGyWC7vrZuZAgV7V4ECyDdH7a6', 'Litecoin')
        expect(described_class).to be_valid('mzBc4XEFSdzCDcTxAgf6EZXgsZWpztRhef', 'Litecoin', :test)

        expect(described_class).to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'LTC')
        expect(described_class).to be_valid('2MxKEf2su6FGAUfCEAHreGFQvEYrfYNHvL7', 'LTC', :test)
        expect(described_class).to be_valid('QW2SvwjaJU8LD6GSmtm1PHnBG2xPuxwZFy', 'LTC', :test)
        expect(described_class).to be_valid('QjpzxpbLp5pCGsCczMbfh1uhC3P89QZavY', 'LTC', :test)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :zec)
        expect(described_class).not_to be_valid('t1Y9yhDa5XEjgfnTgZoKddeSiEN1aoLkQxq', :zcash)
        expect(described_class).not_to be_valid('t3Yz22vK5z2LcKEdg16Yv4FFneEL1zg9ojd', :ZEC)
        expect(described_class).not_to be_valid('t2YNzUUx8mWBCRYPRezvA363EYXyEpHokyi', :zcash, :test)
      end
    end
  end

  describe '.address' do
    it 'returns insance' do
      expect(described_class.address('D1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'eth')).to be_kind_of(AdequateCryptoAddress::Eth)
    end

    it 'raises UnknownCurrency with unknown currency' do
      expect { described_class.address('addr', 'asdf') }.to raise_error(AdequateCryptoAddress::UnknownCurrency, /asdf/)
    end
  end
end
