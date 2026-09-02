
AdequateCryptoAddress
===============

[![Gem Version][gem-version-svg]][gem-version-link]
[![Build Status][build-status-svg]][build-status-link]
[![Coverage Status][coverage-status-svg]][coverage-status-link]
[![Downloads][downloads-svg]][downloads-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

Simple wallet address validator and normalizer for cryptocurrencies addresses in Ruby.

Inspired by [ognus/wallet-address-validator](https://github.com/ognus/wallet-address-validator).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adequate_crypto_address'
```

Or install it yourself as:

```bash
gem install adequate_crypto_address
```

## Upgrading to 0.3.0

0.3.0 is additive and has no breaking changes — upgrade freely. It adds
validators for TRON (`trx`/`tron`), Tezos (`xtz`/`tezos`), Cosmos
(`atom`/`cosmos`), and BNB Smart Chain (`bsc`/`binancesmartchain`); see the
[supported crypto currencies](#supported-crypto-currencies) list for their
types. If you are coming from 0.1.x, also read the notes below.

## Upgrading from 0.1.x to 0.2.0

0.2.0 hardens the validators against malformed input and makes the
`address_type` API consistent. Most callers of `.valid?` need no changes, but a
few behaviors changed. See the [CHANGELOG](CHANGELOG.md) for the full list.

### Stricter validation (addresses that used to pass may now fail)

Some malformed addresses that earlier versions incorrectly accepted are now
rejected. If your app stored or allow-listed such values, re-validate them:

- **BCH** legacy addresses with a bad checksum/length, CashAddr addresses with a
  non-`bitcoincash`/`bchtest`/`bchreg` prefix (e.g. `evil:...`), or a payload
  shorter than the version byte declares.
- **TON** any 48-character string (e.g. `"A" * 48`) — a valid tag, workchain,
  and CRC16 checksum are now required.
- **Monero** anything that is not a checksum-valid Base58 address (e.g.
  `"4" + "!" * 94`).

If you rely on a currency name, note that unknown names still raise
`AdequateCryptoAddress::UnknownCurrency`, but a `nil` or malformed **address**
now consistently returns `false` from `.valid?` instead of raising.

### `address_type` is now public and consistent

`AdequateCryptoAddress.address_type(address, currency)` is a supported public
method for every currency. It returns the detected type as a `Symbol` when the
address is valid, or `nil` when it is not.

Some returned type symbols changed. Update any code that compared against the
old values:

| Currency | 0.1.x           | 0.2.0                                        |
| -------- | --------------- | -------------------------------------------- |
| TON      | `:TON`          | `:ton_mainnet` / `:ton_testnet`              |
| Monero   | `:monero`       | `:standard` / `:integrated` / `:subaddress`  |
| ETH      | `nil`           | `:eth`                                        |
| SOL      | `nil`           | `:solana`                                     |
| XLM      | `nil`           | `:account` / `:muxed`                         |

```ruby
# 0.1.x
AdequateCryptoAddress::Ton.new(addr).send(:address_type) # private, => :TON

# 0.2.0
AdequateCryptoAddress.address_type(addr, :TON)           # public, => :ton_mainnet
```

Type symbols passed to `.valid?` for these currencies changed accordingly, e.g.
`valid?(addr, :TON, :ton_mainnet)`.

### New network accessors

SegWit Bitcoin types are network-agnostic; call `.network` to enforce a network:

```ruby
AdequateCryptoAddress.address('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq', :btc).network #=> :mainnet
AdequateCryptoAddress.address('tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx', :btc).network #=> :testnet
```

`Xmr#network` reports `:mainnet` / `:testnet` / `:stagenet`.

### Internal rename (only if you subclassed `Bch`)

The BCH internal helper `address_type(address_code, address_type)` was renamed
to `type_mapping(address_code, address_type)`. The public `address_type` (no
arguments) now returns the detected type.

## Main API

##### .valid? (address, currency [, type = nil])

###### Parameters
* address - Wallet address to validate.
* currency - Currency name string or symbol in any case, `:bitcoin` or `'BTC'` or `:btc` or `'BitCoin'`
* type - Optional. You can enforce validation with specific type. Not all currencies support types.

> Returns true if the address (string) is a valid wallet address for the crypto currency specified, see below for supported currencies. An unknown currency raises `AdequateCryptoAddress::UnknownCurrency`; a `nil` or malformed address returns `false`.

##### .address_type (address, currency)

> Returns the detected address type as a `Symbol` when the address is valid for the currency, or `nil` when it is not. The type vocabulary per currency is listed below.

```ruby
AdequateCryptoAddress.address_type('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq', :btc) #=> :segwit_v0_keyhash
AdequateCryptoAddress.address_type('not a real address', :btc)                       #=> nil
```

### Supported crypto currencies

* Bitcoin/BTC, `'bitcoin'` or `'BTC'` types: `:segwit_v0_keyhash :segwit_v0_scripthash :taproot :hash160 :p2sh :hash160test :p2shtest`. SegWit types are network-agnostic; call `AdequateCryptoAddress.address(addr, :btc).network` to get `:mainnet`/`:testnet`.
* BitcoinCash/BCH, `'bitcoincash'` or `'BCH'` types: `:p2sh :p2pkh :p2pkhtest :p2shtest`
* Cardano/ADA, `'cardano'` or `'ADA'` types: `:prod :test`
* Dash, `'dash'` or `'DASH'` types: `:prod :test`
* Dogecoin/DOGE, `'dogecoin'` or `'DOGE'` types: `:prod :test`
* Zcash/ZEC, `'zcash'` or `'ZEC'` types: `:prod :test`
* Ethereum/ETH, `'ethereum'` or `'ETH'` type: `:eth`
* Litecoin/LTC, `'litecoin'` or `'LTC'` types: `:prod :test`
* Ripple/XRP, `'ripple'` or `'XRP'` type: `:common`
* Solana/SOL, `'solana'` or `'SOL'` type: `:solana`
* Stellar/XLM, `'stellar'` or `'XLM'` types: `:account :muxed`
* Toncoin/TON, `'TON'` or `'Toncoin'` types: `:ton_mainnet :ton_testnet`
* Monero/XMR, `'monero'` or `'XMR'` types: `:standard :integrated :subaddress` (`.network` reports `:mainnet`/`:testnet`/`:stagenet`)
* TRON/TRX, `'tron'` or `'TRX'` type: `:prod`
* Tezos/XTZ, `'tezos'` or `'XTZ'` types: `:implicit :originated`
* Cosmos/ATOM, `'cosmos'` or `'ATOM'` type: `:prod`
* BNB Smart Chain/BSC, `'bsc'` or `'binancesmartchain'` type: `:bsc` (Ethereum-format address)

### Format coverage

This gem validates the mainstream, checksum-bearing **payment** address for each
supported chain. The following related formats are currently **out of scope** and
are rejected (they return `false`) rather than silently accepted. They may be
added in future releases:

* Bitcoin witness versions 2–16 and newer output forms (e.g. P2MR / BIP-360);
  only v0 (Bech32) and v1 Taproot (Bech32m) are recognized.
* Litecoin MWEB (`ltcmweb1...`) addresses and future witness versions.
* Zcash Sapling, Unified, Orchard, and TEX addresses; only transparent
  `t`-addresses are validated.
* XRP X-addresses (with embedded destination tags); only classic `r...`
  addresses are validated.
* Dash Platform Bech32m addresses; only Core Base58Check addresses are validated.
* Cardano Byron and stake/reward addresses; only Shelley payment address
  types 0–7 are validated. Stake addresses are intentionally excluded from a
  payment-address validator.
* Stellar contract (`C...`) and other SEP-23 StrKey types; only `G` (account)
  and `M` (muxed) addresses are validated.
* TON raw `workchain:account_id` addresses; only the Base64URL user-friendly
  form is validated.

## Usage

### Validation
``` ruby
require 'adequate_crypto_address'
# BTC
AdequateCryptoAddress.valid?('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'BTC') #=> true
AdequateCryptoAddress.valid?('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', :bitcoin, :p2sh) #=> true

# BCH
AdequateCryptoAddress.valid?('bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', :bch) #=> true
AdequateCryptoAddress.valid?('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD', :BCH, :p2pkhtest) #=> true

# ETH
AdequateCryptoAddress.valid?('0xde709f2102306220921060314715629080e2fb77', :ETH) #=> true
AdequateCryptoAddress.valid?('de709f2102306220921060314715629080e2fb77', :ethereum) #=> true
```

### Normalization
###### *Not all currencies support this feature.
``` ruby
require 'adequate_crypto_address'

# BCH
AdequateCryptoAddress.address('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD', 'bch').cash_address #=> "bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf"
AdequateCryptoAddress.address('bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', 'bch').legacy_address #=> "1LcerwTc1oPsMtByDCNUXFxReZpN1EXHoe"

address_string = 'qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk'
addr = AdequateCryptoAddress.address(address_string, 'bch')
addr.prefix #=> "bitcoincash"
addr.type #=> :p2pkh
addr.address #=> "bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk"

# ETH
AdequateCryptoAddress.address('D1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'eth').address #=> "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb"
```


### ActiveRecord validation example
``` ruby
class Model < ActiveRecord::Base
  attribute :address, :string
  attribute :dest_tag, :string
  attribute :currency, :string

  validate  :validate_address_type
  validate  :validate_destination_tag

  def validate_address_type
    errors.add(:address, 'invalid address') unless AdequateCryptoAddress.valid?(address, currency)
  end

  # for Ripple
  def validate_destination_tag
    errors.add(:dest_tag, 'invalid destination tag') if dest_tag.present? && !(dest_tag =~ /\A\d{1,10}\z/)
  end
end

```
### Add your currency
``` ruby
# frozen_string_literal: true
# for Rails /config/initializers/adequate_crypto_address.rb
module AdequateCryptoAddress
  class Coin
    attr_reader :address

    def initialize(address_sring)
      @address = address_sring
    end

    def valid?(_type)
      address.present?
    end
  end
end

AdequateCryptoAddress.valid?('addr', :coin) #=> true
```

## Development

The repository pins Ruby with [mise](https://mise.jdx.dev/). Install the toolchain and dependencies, then run
the complete local quality gate:

```bash
mise trust
mise install
mise run setup
mise run check
```

Individual tasks are available as `mise run test`, `mise run lint`, and `mise run build`. Use
`mise run console` for an interactive prompt.

## Contributing

1. Fork [the repo](https://github.com/vtm9/adequate_crypto_address)
2. Trust and install the toolchain: `mise trust && mise install`
3. Grab dependencies: `mise run setup`
4. Make your changes
5. Make sure everything is working: `mise run check`
6. Create a pull request

## Notes

Bug reports and pull requests are welcome on GitHub at https://github.com/vtm9/adequate_crypto_address/issues

[gem-version-svg]: https://img.shields.io/gem/v/adequate_crypto_address.svg
[gem-version-link]: https://rubygems.org/gems/adequate_crypto_address
[downloads-svg]: https://img.shields.io/gem/dt/adequate_crypto_address.svg
[downloads-link]: https://rubygems.org/gems/adequate_crypto_address
[build-status-svg]: https://github.com/vtm9/adequate_crypto_address/actions/workflows/ci.yml/badge.svg?branch=master
[build-status-link]: https://github.com/vtm9/adequate_crypto_address/actions/workflows/ci.yml
[coverage-status-svg]: https://coveralls.io/repos/vtm9/adequate_crypto_address/badge.svg?branch=master
[coverage-status-link]: https://coveralls.io/r/vtm9/adequate_crypto_address?branch=master
[docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
[docs-rubydoc-link]: http://www.rubydoc.info/gems/adequate_crypto_address/
[license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
[license-link]: https://github.com/vtm9/adequate_crypto_address/blob/master/LICENSE.txt
