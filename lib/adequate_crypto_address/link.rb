# frozen_string_literal: true

module AdequateCryptoAddress
  class Link < Eth
    ADDRESS_TYPES = { prod: %w[], test: %w[] }.freeze
  end
  Link = Link
end
