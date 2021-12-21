# frozen_string_literal: true

module AdequateCryptoAddress
  class Audio < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Audius = Audio
end
