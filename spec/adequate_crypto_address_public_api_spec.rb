# frozen_string_literal: true

RSpec.describe(AdequateCryptoAddress, :aggregate_failures) do
  # One representative valid address per currency, with the expected public
  # address_type. The Monero standard address is the getmonero.org donation
  # address; the rest are canonical vectors reused from the public API spec.
  let(:valid_addresses) do
    monero = '44AFFq5kSiGBoZ4NMDwYtN18obc8AemS33DBLWs3H7otXft3XjrpDtQGv7SqSsaBYBb98uNbr2VBBEt7f2wfn3RVGQBEP3A'
    {
      btc: ['12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', :hash160],
      bch: ['bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h', :p2pkh],
      eth: ['0xde709f2102306220921060314715629080e2fb77', :eth],
      xrp: ['rPMLwSwyyULN2acf5JKB1nj8F8Eu8pVMV8', :common],
      dash: ['Xx4dYKgz3Zcv6kheaqog3fynaKWjbahb6b', :prod],
      zec: ['t1U9yhDa5XEjgfnTgZoKddeSiEN1aoLkQxq', :prod],
      ltc: ['LVg2kJoFNg45Nbpy53h7Fe1wKyeXVRhMH9', :prod],
      doge: ['DKRgRWjzZA6VPZGdTFgk1or8qiz2xZuhTM', :prod],
      sol: ['7xKXtg2CW87d97TXJSDpbD5xJQ3x6QhN5cQj7h4Fq3V', :solana],
      xlm: ['GD327MCKE45GYHWG22L7EJFULEUDMNOWGWW5WFBE5QD3CYLCI44XITXN', :account],
      ada: ['addr1wx6hd6gradhx8m7l2sn5w8pp2vuh22glwq65w07wjfqlf7qlh3dvr', :prod],
      ton: ['UQCScs4HjjwnlIFKIq_juiuLLLnjJKTjQyfcADjYNvdYwn-l', :ton_mainnet],
      xmr: [monero, :standard],
      trx: ['TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t', :prod],
      xtz: ['tz1burnburnburnburnburnburnburjAYjjX', :implicit],
      atom: ['cosmos1depk54cuajgkzea6zpgkq36tnjwdzv4afc3d27', :prod],
      bsc: ['0xE37c0D48d68da5c5b14E5c1a9f1CFE802776D9FF', :bsc]
    }
  end

  describe '.address_type' do
    it 'returns the detected type for valid addresses across every currency' do
      valid_addresses.each do |currency, (address, type)|
        expect(described_class.address_type(address, currency)).to eq(type)
      end
    end

    it 'returns nil for invalid addresses across every currency' do
      valid_addresses.each_key do |currency|
        expect(described_class.address_type('definitely not valid', currency)).to be_nil
      end
    end

    it 'returns nil for nil input instead of raising' do
      valid_addresses.each_key do |currency|
        expect { described_class.address_type(nil, currency) }.not_to raise_error
        expect(described_class.address_type(nil, currency)).to be_nil
      end
    end
  end

  describe '.valid?' do
    it 'returns false for nil input instead of raising' do
      valid_addresses.each_key do |currency|
        expect { described_class.valid?(nil, currency) }.not_to raise_error
        expect(described_class).not_to be_valid(nil, currency)
      end
    end

    it 'rejects single-character checksum mutations for every checksummed currency' do
      # Solana keys and Ethereum lowercase addresses carry no checksum, so they
      # are validated structurally and excluded from this mutation sweep.
      valid_addresses.except(:sol, :eth).each do |currency, (address, _type)|
        mutated = mutate(address)
        expect(described_class).to be_valid(address, currency)
        expect(described_class).not_to be_valid(mutated, currency)
      end
    end

    it 'rejects oversized input quickly without decoding' do
      oversized = '1' * 5_000
      [:btc, :bch, :xrp, :dash, :zec, :ltc, :doge, :sol, :xlm, :ada, :xmr, :trx, :xtz, :atom].each do |currency|
        expect(described_class).not_to be_valid(oversized, currency)
      end
    end
  end

  describe '.address' do
    it 'raises UnknownCurrency for unknown currency names' do
      ['nope', :nope, 'Bitcoinz'].each do |currency|
        expect { described_class.address('x', currency) }
          .to raise_error(AdequateCryptoAddress::UnknownCurrency)
      end
    end

    it 'does not resolve non-validator constants to a currency' do
      %w[utils version invalidaddress unknowncurrency].each do |currency|
        expect { described_class.address('x', currency) }
          .to raise_error(AdequateCryptoAddress::UnknownCurrency)
      end
    end
  end

  # Replace one interior character with a different value from the same
  # alphabet, producing a checksum mismatch without changing the length.
  def mutate(address)
    index = address.length / 2
    original = address[index]
    replacement = original.match?(/[a-z]/) && original != 'a' ? 'a' : 'b'
    replacement = original == 'A' ? 'B' : 'A' if original.match?(/[A-Z]/)
    replacement = original == '2' ? '3' : '2' if original.match?(/[0-9]/)
    address.dup.tap { |copy| copy[index] = replacement }
  end
end
