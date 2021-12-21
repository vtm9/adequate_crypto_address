# frozen_string_literal: true

module AdequateCryptoAddress
  class Axs < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  AxieInfinityShard = Axs
end
