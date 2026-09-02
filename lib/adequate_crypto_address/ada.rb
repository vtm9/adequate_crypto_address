# frozen_string_literal: true

module AdequateCryptoAddress
  class Ada
    attr_reader :address, :type

    BASE_ADDRESS_TYPES = [0, 1, 2, 3].freeze
    POINTER_ADDRESS_TYPES = [4, 5].freeze
    ENTERPRISE_ADDRESS_TYPES = [6, 7].freeze
    VALID_ADDRESS_TYPES = (BASE_ADDRESS_TYPES + POINTER_ADDRESS_TYPES + ENTERPRISE_ADDRESS_TYPES).freeze

    def initialize(address)
      @address = address
      @type = address_type
    end

    def valid?(type = nil)
      if type
        address_type == type.to_sym
      else
        !address_type.nil?
      end
    end

    private

    def address_type
      decoded = begin
        decode_address
      rescue StandardError
        nil
      end

      return nil unless decoded

      bytes, hrp = decoded

      header = bytes.first
      addr_type = header >> 4
      network = header & 0x0f

      return nil unless VALID_ADDRESS_TYPES.include?(addr_type)

      return :prod if hrp == 'addr' && network == 1
      return :test if hrp == 'addr_test' && network.zero?

      nil
    end

    def decode_address
      actual_hrp, data, encoding = Utils::Bech32.decode(
        address,
        ignore_length: true,
        include_encoding: true
      )

      return nil unless %w[addr addr_test].include?(actual_hrp)
      return nil unless encoding == :bech32

      bytes = Utils::Bech32.convert_bits(
        data,
        from_bits: 5,
        to_bits: 8,
        pad: false
      )

      return nil unless bytes
      return nil if bytes.empty?

      header = bytes.first
      addr_type = header >> 4

      return nil unless valid_length?(addr_type, bytes)

      [bytes, actual_hrp]
    end

    def valid_length?(addr_type, bytes)
      case addr_type
      when *BASE_ADDRESS_TYPES
        # header (1) + payment hash (28) + stake hash (28)
        bytes.length == 57
      when *POINTER_ADDRESS_TYPES
        valid_pointer?(bytes.drop(29))
      when *ENTERPRISE_ADDRESS_TYPES
        # header (1) + payment hash (28)
        bytes.length == 29
      else
        false
      end
    end

    def valid_pointer?(pointer)
      return false if pointer.length < 3

      index = 0
      3.times do
        first_byte = true
        loop do
          return false if index >= pointer.length

          byte = pointer[index]
          index += 1
          return false if first_byte && byte == 0x80

          first_byte = false
          break if (byte & 0x80).zero?
        end
      end

      index == pointer.length
    end
  end

  Cardano = Ada
end
