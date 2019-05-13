# frozen_string_literal: true

RSpec.describe(AdequateCryptoAddress::Bch) do
  let(:legacy_p2sh) { '3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTzC' }
  let(:legacy_p2pkh) { '155fzsEBHy9Ri2bMQ8uuuR3tv1YzcDywd4' }
  let(:cashaddr_p2sh) { 'bitcoincash:ppm2qsznhks23z7629mms6s4cwef74vcwvn0h829pq' }
  let(:cashaddr_p2pkh) { 'bitcoincash:qqkv9wr69ry2p9l53lxp635va4h86wv435995w8p2h' }
  let(:cashaddr_p2pkh_testnet) { 'bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf' }
  let(:legacy_p2pkh_testnet) { 'mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD' }
  let(:cashaddr_p2sh_testnet) { 'bchtest:pp8f7ww2g6y07ypp9r4yendrgyznysc9kqxh6acwu3' }
  let(:legacy_p2sh_testnet) { '2MzQwSSnBHWHqSAqtTVQ6v47XtaisrJa1Vc' }
  let(:mixed_case_cashadddr) { 'bitcoincash:qqkv9wr69ry2p9l53lxP635va4h86wv435995w8p2H' }

  describe '#legacy_address' do
    it 'converts legacy testnet p2pkh' do
      expect(described_class.new(legacy_p2pkh_testnet).legacy_address).to eq(legacy_p2pkh_testnet)
      expect(described_class.new(cashaddr_p2pkh_testnet).legacy_address).to eq(legacy_p2pkh_testnet)
    end

    it 'converts legacy testnet p2sh' do
      expect(described_class.new(legacy_p2sh_testnet).legacy_address).to eq(legacy_p2sh_testnet)
      expect(described_class.new(cashaddr_p2sh_testnet).legacy_address).to eq(legacy_p2sh_testnet)
    end

    it 'converts to legacy p2sh' do
      expect(described_class.new(legacy_p2sh).legacy_address).to eq(legacy_p2sh)
      expect(described_class.new(cashaddr_p2sh).legacy_address).to eq(legacy_p2sh)
    end

    it 'converts to legacy p2pkh' do
      expect(described_class.new(legacy_p2pkh).legacy_address).to eq(legacy_p2pkh)
      expect(described_class.new(cashaddr_p2pkh).legacy_address).to eq(legacy_p2pkh)
    end

    context 'uppercase cashaddr address' do
      it 'converts to legacy p2sh' do
        expect(described_class.new(cashaddr_p2sh.upcase).legacy_address).to eq(legacy_p2sh)
      end

      it 'converts to legacy p2pkh' do
        expect(described_class.new(cashaddr_p2pkh.upcase).legacy_address).to eq(legacy_p2pkh)
      end
    end
  end

  context '#cash_address' do
    it 'converts cash testnet p2pkh' do
      expect(described_class.new(legacy_p2pkh_testnet).cash_address).to eq(cashaddr_p2pkh_testnet)
      expect(described_class.new(cashaddr_p2pkh_testnet).cash_address).to eq(cashaddr_p2pkh_testnet)
    end

    it 'converts cash testnet p2sh' do
      expect(described_class.new(legacy_p2sh_testnet).cash_address).to eq(cashaddr_p2sh_testnet)
      expect(described_class.new(cashaddr_p2sh_testnet).cash_address).to eq(cashaddr_p2sh_testnet)
    end

    it 'converts to cash p2sh' do
      expect(described_class.new(legacy_p2sh).cash_address).to eq(cashaddr_p2sh)
      expect(described_class.new(cashaddr_p2sh).cash_address).to eq(cashaddr_p2sh)
    end

    it 'converts to cash p2pkh' do
      expect(described_class.new(legacy_p2pkh).cash_address).to eq(cashaddr_p2pkh)
      expect(described_class.new(cashaddr_p2pkh).cash_address).to eq(cashaddr_p2pkh)
    end

    context 'uppercase cashaddr address' do
      it 'converts to cash p2sh' do
        expect(described_class.new(cashaddr_p2sh.upcase).cash_address).to eq(cashaddr_p2sh)
      end

      it 'converts to cash p2pkh' do
        expect(described_class.new(cashaddr_p2pkh.upcase).cash_address).to eq(cashaddr_p2pkh)
      end
    end
  end
end
