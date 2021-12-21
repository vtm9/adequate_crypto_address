# frozen_string_literal: true

module AdequateCryptoAddress
  class Okb < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  OKBlockchain = Okb
end
