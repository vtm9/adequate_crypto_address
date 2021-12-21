# frozen_string_literal: true

module AdequateCryptoAddress
  class Snx < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  SynthetixNetworkToken = Snx
end
