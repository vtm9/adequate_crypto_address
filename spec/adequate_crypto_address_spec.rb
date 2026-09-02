# frozen_string_literal: true

RSpec.describe(AdequateCryptoAddress, :aggregate_failures) do
  describe '.valid?' do
    describe 'Bitcoin' do
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
        expect(described_class).to be_valid('bc1qc7slrfxkknqcq2jevvvkdgvrt8080852dfjewde450xdlk4ugp7szw5tk9',
                                            'bitcoin', :segwit_v0_scripthash)
        # testnet3 / testnet4
        expect(described_class).to be_valid('tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx', 'BTC')
        expect(described_class).to be_valid('tb1qg3hss5p9g9jp0es5u5aaz3lszf6cvdggtmjarr', 'bitcoin', :segwit_v0_keyhash)
        expect(described_class).to be_valid(
          'tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7',
          'bitcoin',
          :segwit_v0_scripthash
        )
      end

      it 'validates taproot addresses' do
        expect(described_class).to be_valid('bc1p5cyxnuxmeuwuvkwfem96lqzszd02n6xdcjrs20cac6yqjjwudpxqkedrcr', 'bitcoin')
        expect(described_class).to be_valid('bc1p5cyxnuxmeuwuvkwfem96lqzszd02n6xdcjrs20cac6yqjjwudpxqkedrcr', 'BTC',
                                            :taproot)
        # testnet3 / testnet4
        expect(described_class).to be_valid('tb1pzt53e6nghqw40zglfzn56cdj82xx68nsd84z3yn5pl6xxj2v3n9qrsheeh', 'BTC')
        expect(described_class).to be_valid('tb1pjfdm902y2adr08qnn4tahxjvp6x5selgmvzx63yfqk2hdey02yvqjcr29q',
                                            'bitcoin', :taproot)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('asdf', :bitcoin)
        expect(described_class).not_to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'bitcoin', :segwit_v0_keyhash)
        expect(described_class).not_to be_valid('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', 'bitcoin', 'asdf')
        expect(described_class).not_to be_valid('tc1qw508d6qejxtdg4y5r3zarvary0c5xw7kg3g4ty', :bitcoin)
        expect(described_class).not_to be_valid('bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t5', 'bitcoin')
        expect(described_class).not_to be_valid('BC13W508D6QEJXTDG4Y5R3ZARVARY0C5XW7KN40WF2', 'bitcoin')
        expect(described_class).not_to be_valid('bc1rw5uspcuh', 'bitcoin')
        expect(described_class).not_to be_valid(
          'bc10w508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kw5rljs90', 'bitcoin'
        )
        expect(described_class).not_to be_valid('BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P', 'bitcoin')
        expect(described_class).not_to be_valid('tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sL5k7', 'BTC')
        expect(described_class).not_to be_valid('bc1zw508d6qejxtdg4y5r3zarvaryvqyzf3du', 'bitcoin')
        expect(described_class).not_to be_valid('tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3pjxtptv',
                                                'Bitcoin')
        expect(described_class).not_to be_valid('bc1gmk9yu', 'bitcoin')
        # Invalid checksum.
        expect(described_class).not_to be_valid(
          'bc1p5d7rjq7g6rdk2yhzks9smlqfpuecypus6uf4e9qrsssrwc09', 'bitcoin'
        )
        # Too short.
        expect(described_class).not_to be_valid(
          'bc1p5d7rjq7g6rdk2yhzks9smlqfpuecypus6uf4e9qrsssrwc0', 'bitcoin'
        )
        # BIP-350: v0 must use Bech32 and v1+ must use Bech32m.
        expect(described_class).not_to be_valid(
          'tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47',
          'bitcoin'
        )
        expect(described_class).not_to be_valid(
          'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd',
          'bitcoin'
        )
      end
    end

    describe 'Bitcoincash' do
      it 'validates legacy addresses' do
        expect(described_class).to be_valid('3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTzC', :bch, :p2sh)
        expect(described_class).to be_valid('155fzsEBHy9Ri2bMQ8uuuR3tv1YzcDywd4', 'bitcoincash', :p2pkh)
        expect(described_class).to be_valid('2MzQwSSnBHWHqSAqtTVQ6v47XtaisrJa1Vc', 'BCH', :p2shtest)
        expect(described_class).to be_valid('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD', :BCH, :p2pkhtest)
      end

      it 'validates cash addresses' do
        expect(described_class).to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h', :bch, :p2pkh)
        expect(described_class).to be_valid('bitcoincash:pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash,
                                            :p2sh)
        expect(described_class).to be_valid('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf', :Bitcoincash,
                                            :p2pkhtest)
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

        expect(described_class).not_to be_valid('bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h', :bch,
                                                :p2pkhtest)
        expect(described_class).not_to be_valid('bitcoincash:pqdg9uq52wzhf228hweext9j2jdjgdpj9qt7xxfngd', :bitcoincash,
                                                :p2pkhtest)
        expect(described_class).not_to be_valid('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf', :Bitcoincash,
                                                :p2sh)
        expect(described_class).not_to be_valid('bchtest:pp8f7ww2g6y07ypp9r4yendrgyznysc9kqxh6acwu3', :BCH, :p2sh)
      end

      it 'rejects hardened attack vectors' do
        # CashAddr with a valid checksum but a disallowed prefix.
        expect(described_class).not_to be_valid('evil:qqqsyqcyq5rqwzqfpg9scrgwpugpzysnzsqsced5n7', :bch)
        # CashAddr whose version claims a 20-byte hash but carries a shorter payload.
        expect(described_class).not_to be_valid('bitcoincash:qqqsyqcyq5rqwzqfpgkdg623ng', :bch)
        # Legacy Base58Check address with a single mutated checksum character.
        expect(described_class).to be_valid('3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTzC', :bch)
        expect(described_class).not_to be_valid('3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTzD', :bch)
      end
    end

    describe 'Ethereum' do
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

    describe 'Ripple' do
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

    describe 'Dash' do
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

    describe 'Zcash' do
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

    describe 'Litecoin' do
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
        expect(described_class).to be_valid('tltc1pxdvk48nchp45mcg8pcht5ss8ladtxnl7mkr96lrw93q79g407ufqmelwuu', 'LTC',
                                            :test)
        expect(described_class).to be_valid('tltc1pxdvk48nchp45mcg8pcht5ss8ladtxnl7mkr96lrw93q79g407ufqmelwuu', 'LTC')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :zec)
        expect(described_class).not_to be_valid('t1Y9yhDa5XEjgfnTgZoKddeSiEN1aoLkQxq', :zcash)
        expect(described_class).not_to be_valid('t3Yz22vK5z2LcKEdg16Yv4FFneEL1zg9ojd', :ZEC)
        expect(described_class).not_to be_valid('t2YNzUUx8mWBCRYPRezvA363EYXyEpHokyi', :zcash, :test)
        expect(described_class).not_to be_valid('tltc1pxdvk48nchp45mcg8pcht5ss8ladtxnl7mkr96lrw93q79g407ufqmelwuu',
                                                'LTC', :prod)
        expect(described_class).not_to be_valid('tltc1Pxdvk48nchp45mcg8pcht5ss8ladtxnl7mkr96lrw93q79g407ufqmelwuu',
                                                'LTC')
      end
    end

    describe 'Cardano' do
      it 'validates addresses' do
        expect(described_class).to be_valid(
          'addr1z84q0denmyep98ph3tmzwsmw0j7zau9ljmsqx6a4rvaau66j2c79gy9l76sdg0xwhd7r0c0kna0tycz4y5s6mlenh8pq777e2a',
          :ada
        )
        expect(described_class).to be_valid(
          'addr1q9dhugez3ka82k2kgh7r2lg0j7aztr8uell46kydfwu3vk6n8w2cdu8mn2ha278q6q25a9rc6gmpfeekavuargcd32vsvxhl7e',
          'ADA', :prod
        )
        expect(described_class).to be_valid(
          'addr1q8gg2r3vf9zggn48g7m8vx62rwf6warcs4k7ej8mdzmqmesj30jz7psduyk6n4n2qrud2xlv9fgj53n6ds3t8cs4fvzs05yzmz',
          'Cardano'
        )
        expect(described_class).to be_valid('addr1wx6hd6gradhx8m7l2sn5w8pp2vuh22glwq65w07wjfqlf7qlh3dvr', 'Cardano')
        expect(described_class).to be_valid(
          'addr1gx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer5pnz75xxcrzqf96k',
          'Cardano',
          :prod
        )
        expect(described_class).to be_valid(
          'addr128phkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtupnz75xxcrtw79hu',
          'ADA'
        )

        expect(described_class).to be_valid(
          'addr_test1qqx3d3kxe37k76wrpeck338g6zk47hjfz6t04t7n8m7t8yjkvjhxw6ysgfejsde09fmtznsnwzaphdl774qh49nu7vcsgq5wqa',
          'ADA', :test
        )
        expect(described_class).to be_valid(
          'addr_test1qp4q5p7zj32vcd07ncywvuh0ca99p2w4fnv547ua5utmsuv0pten2usz500r333ck0v0amvvqdgxyrrh4t6swagsl4zsp7d6r8',
          'Cardano', :test
        )
        expect(described_class).to be_valid('addr_test1vr842a8uhw3pd3m4dqqgkm7p8fhy75grudpr8jht58yygzqtfcv4g',
                                            'Cardano', :test)
        expect(described_class).to be_valid(
          'addr_test1gz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer5pnz75xxcrdw5vky',
          'Cardano',
          :test
        )
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :ada)
        expect(described_class).not_to be_valid(
          'addr1z84q0denmyep98ph3tmewsmw0j7zau9ljmsqx6a4rvaau66j2c79gy9l76sdg0xwhd7r0c0kna0tycz4y5s6mlenh8pq777e2a',
          :ada
        )
        expect(described_class).not_to be_valid(
          'addr1q9dhugez3ka82k2kgh7r4lg0j7aztr8uell46kydfwu3vk6n8w2cdu8mn2ha278q6q25a9rc6gmpfeekavuargcd32vsvxhl7e',
          'ADA', :prod
        )
        expect(described_class).not_to be_valid('addr1v9jxv7k0z9m3k4f0k8h5l6h9m7q3x6w8v0j7q2x0r8z5h0k9d2', 'Cardano')
        expect(described_class).not_to be_valid(
          'addr_test1qp4q5p7zj32vcd07nnywvuh0ca99p2w4fnv547ua5utmsuv0pten2usz500r333ck0v0amvvqdgxyrrh4t6swagsl4zsp7d6r8',
          'Cardano', :test
        )
        # Cardano uses Bech32, not Bech32m.
        expect(described_class).not_to be_valid(
          'addr1wx6hd6gradhx8m7l2sn5w8pp2vuh22glwq65w07wjfqlf7q2tppfp',
          'Cardano'
        )
      end
    end

    describe 'Dogecoin' do
      it 'validates addresses' do
        expect(described_class).to be_valid('DKRgRWjzZA6VPZGdTFgk1or8qiz2xZuhTM', :doge)
        expect(described_class).to be_valid('A1hZnfuStUP9U6Uzg6CsV3n2c5As4UQ3c5', 'doge', :prod)
        expect(described_class).to be_valid('AF3trXVo9LwoJsM1XigvMBxWGt7yYATp8t', 'DOGE')
        expect(described_class).to be_valid('DDz1H7AcqPgmKzFEP3pBHW5b1GWuWEoAAP', 'Dogecoin')
        expect(described_class).to be_valid('nmu9w14qnskUY8xygaDMnGkYeAAbwmEi1i', 'Dogecoin', :test)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :doge)
        expect(described_class).not_to be_valid('DKRgRZjzZA6VPZGdTFgk1or8qiz2xZuhTM', :doge)
        expect(described_class).not_to be_valid('AF3trYVo9LwoJsM1XigvMBxWGt7yYATp8t', 'Dogecoin')
        expect(described_class).not_to be_valid('nZBUZ085136wmU5s7Mmb4QecTdbAJbK4gZ', 'Dogecoin', :test)
      end
    end

    describe 'Solana' do
      it 'validates addresses' do
        expect(described_class).to be_valid('7xKXtg2CW87d97TXJSDpbD5xJQ3x6QhN5cQj7h4Fq3V', :sol)
        expect(described_class).to be_valid('7xKXtg2CW87d97TXJSDpbD5xJQ3x6QhN5cQj7h4Fq3V', 'SOL')
        expect(described_class).to be_valid('7xKXtg2CW87d97TXJSDpbD5xJQ3x6QhN5cQj7h4Fq3V', 'Solana')
        expect(described_class).to be_valid('So11111111111111111111111111111111111111112', :sol)
        expect(described_class).to be_valid('11111111111111111111111111111111', 'Solana')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :sol)
        expect(described_class).not_to be_valid('7xKXtg2CW87d97TXJSDpbD5xJQ3x6QhN5cQj7h4Fq3', :sol)
        expect(described_class).not_to be_valid('7xKXtg2CW87d97TXJSDpbD5xJQ3x6QhN5cQj7h4Fq3V0', 'Solana')
        expect(described_class).not_to be_valid('0xKXtg2CW87d97TXJSDpbD5xJQ3x6QhN5cQj7h4Fq3V', 'SOL')
      end
    end

    describe 'Stellar' do
      it 'validates addresses' do
        expect(described_class).to be_valid('GD327MCKE45GYHWG22L7EJFULEUDMNOWGWW5WFBE5QD3CYLCI44XITXN', :xlm)
        expect(described_class).to be_valid('GAQCCRRVYDTBES66MW5GS6ZCVTLLQP4GLV35WI7TWQQYTMWX7MVHDDPY', 'XLM')
        expect(described_class).to be_valid('GBPGJK2NR6KLWRJOO6FPOQMFNMLLGNHGZCY6ER5MRBTLZN246DFJJ2R2', 'Stellar')
        expect(described_class).to be_valid('MA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAAAAAABUTGI4',
                                            'Stellar')
        expect(described_class).to be_valid('MA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAAAAAAAACJUQ',
                                            'Stellar')
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :xlm)
        expect(described_class).not_to be_valid('GD327MCKE45GYBWG22L7EJFULEUDMNOWGWW5WFBE5QD3CYLCI44XITXN', :xlm)
        expect(described_class).not_to be_valid('GAQCCRRVYDTBES36MW5GS6ZCVTLLQP4GLV35WI7TWQQYTMWX7MVHDDPY', 'XLM')
        expect(described_class).not_to be_valid('GBPGJK2NR6KLWRJOO6FPFQMFNMLLGNHGZCY6ER5MRBTLZN246DFJJ2R2', 'Stellar')
        expect(described_class).not_to be_valid(
          'MA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAABAAAAAAAAACJUQ', 'Stellar'
        )
      end
    end

    describe 'Toncoin' do
      let(:valid_ton) { 'UQCScs4HjjwnlIFKIq_juiuLLLnjJKTjQyfcADjYNvdYwn-l' }

      it 'validates addresses' do
        expect(described_class).to be_valid(valid_ton, :TON)
        expect(described_class).to be_valid(valid_ton, 'Toncoin')
      end

      it 'reports the network as the address type' do
        expect(described_class.address_type(valid_ton, :TON)).to eq(:ton_mainnet)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrongFKIq_juiuLLLnjJKTjQyfcAD', :TON)
        # Correct length and alphabet but no valid tag/workchain/CRC16.
        expect(described_class).not_to be_valid('A' * 48, :TON)
        # Single-character checksum mutation of a real address.
        expect(described_class).not_to be_valid("#{valid_ton[0..-2]}m", :TON)
      end
    end

    describe 'Monero' do
      # Standard mainnet address is the published getmonero.org donation address.
      # The integrated and subaddress vectors are structurally valid (Keccak
      # checksum recomputed) and derived from the same public keys.
      let(:standard) do
        '44AFFq5kSiGBoZ4NMDwYtN18obc8AemS33DBLWs3H7otXft3XjrpDtQGv7SqSsaBYBb98uNbr2VBBEt7f2wfn3RVGQBEP3A'
      end
      let(:integrated) do
        '4DrvGduF3ynBoZ4NMDwYtN18obc8AemS33DBLWs3H7otXft3XjrpDtQGv7SqSsaBYBb98uNbr2VBBEt7f2wfn3RVPp3LfyiRVuc4Ekf4eH'
      end
      let(:subaddress) do
        '84zPbCjb38gBoZ4NMDwYtN18obc8AemS33DBLWs3H7otXft3XjrpDtQGv7SqSsaBYBb98uNbr2VBBEt7f2wfn3RVGMwZRBo'
      end

      it 'validates addresses across currency aliases' do
        [:XMR, :monero, :Xmr, :xmr].each do |currency|
          expect(described_class).to be_valid(standard, currency)
        end
      end

      it 'validates integrated and subaddress forms' do
        expect(described_class).to be_valid(integrated, :monero)
        expect(described_class).to be_valid(subaddress, :monero)
      end

      it 'exposes the decoded address type' do
        expect(described_class.address_type(standard, :xmr)).to eq(:standard)
        expect(described_class.address_type(integrated, :xmr)).to eq(:integrated)
        expect(described_class.address_type(subaddress, :xmr)).to eq(:subaddress)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('NOT_VALID_4BKnGLZNZ5pjpXCZedGfVQjpXCZedGfVQjp', :monero)
        # Non-Base58 characters (regex validator previously accepted this).
        expect(described_class).not_to be_valid("4#{'!' * 94}", :xmr)
        # Single-character checksum mutation of a real address.
        expect(described_class).not_to be_valid("#{standard[0..-2]}Z", :xmr)
      end
    end

    describe 'Tron' do
      it 'validates addresses' do
        expect(described_class).to be_valid('TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t', :trx)
        expect(described_class).to be_valid('TLyqzVGLV1srkB7dToTAEqgDSfPtXRJZYH', 'TRX')
        expect(described_class).to be_valid('TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t', 'Tron', :prod)
        expect(described_class.address_type('TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t', :trx)).to eq(:prod)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :trx)
        # Single-character checksum mutation.
        expect(described_class).not_to be_valid('TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6u', :trx)
        # Ethereum-style address is not a TRON address.
        expect(described_class).not_to be_valid('0xde709f2102306220921060314715629080e2fb77', :trx)
      end
    end

    describe 'Tezos' do
      it 'validates addresses' do
        expect(described_class).to be_valid('tz1burnburnburnburnburnburnburjAYjjX', :xtz)
        expect(described_class).to be_valid('tz1burnburnburnburnburnburnburjAYjjX', 'Tezos', :implicit)
        expect(described_class).to be_valid('KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn', :xtz, :originated)
        expect(described_class.address_type('KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn', :tezos)).to eq(:originated)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :xtz)
        # Single-character checksum mutation.
        expect(described_class).not_to be_valid('tz1burnburnburnburnburnburnburjAYjjY', :xtz)
        # Implicit address queried as an originated (KT1) type.
        expect(described_class).not_to be_valid('tz1burnburnburnburnburnburnburjAYjjX', :xtz, :originated)
      end
    end

    describe 'Cosmos' do
      it 'validates addresses' do
        expect(described_class).to be_valid('cosmos1depk54cuajgkzea6zpgkq36tnjwdzv4afc3d27', :atom)
        expect(described_class).to be_valid('cosmos1depk54cuajgkzea6zpgkq36tnjwdzv4afc3d27', 'Cosmos', :prod)
        expect(described_class.address_type('cosmos1depk54cuajgkzea6zpgkq36tnjwdzv4afc3d27', :atom)).to eq(:prod)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :atom)
        # Single-character checksum mutation.
        expect(described_class).not_to be_valid('cosmos1depk54cuajgkzea6zpgkq36tnjwdzv4afc3d28', :atom)
        # A valid Bech32 address with a non-cosmos human-readable part.
        expect(described_class).not_to be_valid('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq', :atom)
      end
    end

    describe 'BinanceSmartChain' do
      it 'validates addresses' do
        expect(described_class).to be_valid('0xE37c0D48d68da5c5b14E5c1a9f1CFE802776D9FF', :bsc)
        expect(described_class).to be_valid('0xde709f2102306220921060314715629080e2fb77', 'binancesmartchain')
        expect(described_class.address_type('0xE37c0D48d68da5c5b14E5c1a9f1CFE802776D9FF', :bsc)).to eq(:bsc)
      end

      it 'validates wrong addresses' do
        expect(described_class).not_to be_valid('wrong', :bsc)
        # Invalid EIP-55 checksum.
        expect(described_class).not_to be_valid('0xD1110A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', :bsc)
      end
    end
  end

  describe '.address' do
    it 'returns insance' do
      expect(described_class.address('D1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'eth')).to be_a(AdequateCryptoAddress::Eth)
    end

    it 'raises UnknownCurrency with unknown currency' do
      expect { described_class.address('addr', 'asdf') }.to raise_error(AdequateCryptoAddress::UnknownCurrency, /asdf/)
    end
  end
end
