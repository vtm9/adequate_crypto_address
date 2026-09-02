# frozen_string_literal: true

RSpec.describe(AdequateCryptoAddress::Utils::Bech32) do
  describe '.decode' do
    it 'preserves the two-element result by default' do
      decoded = described_class.decode('BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4')

      expect(decoded.length).to eq(2)
    end

    it 'reports Bech32 encoding when requested' do
      decoded = described_class.decode(
        'BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4',
        include_encoding: true
      )

      expect(decoded.last).to eq(:bech32)
    end

    it 'reports Bech32m encoding when requested' do
      decoded = described_class.decode(
        'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0',
        include_encoding: true
      )

      expect(decoded.last).to eq(:bech32m)
    end
  end
end
