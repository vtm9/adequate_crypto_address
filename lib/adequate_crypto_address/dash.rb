# frozen_string_literal: true

module AdequateCryptoAddress
  class Dash < Altcoin
    ADDRESS_TYPES = { prod: %w[4c 10], test: %w[8c 13] }.freeze
  end
end
