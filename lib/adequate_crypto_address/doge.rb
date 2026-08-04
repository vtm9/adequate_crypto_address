# frozen_string_literal: true

module AdequateCryptoAddress
  class Doge < Altcoin
    ADDRESS_TYPES = {
      prod: %w[1e 16],
      test: %w[71 c4]
    }.freeze
  end

  Dogecoin = Doge
end
