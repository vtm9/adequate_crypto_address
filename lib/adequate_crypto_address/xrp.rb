# frozen_string_literal: true

module AdequateCryptoAddress
  class Xrp < Altcoin
    ADDRESS_TYPES = { common: %w[00] }.freeze
    ALPHABET_TYPE = :ripple
  end
  Ripple = Xrp
end
