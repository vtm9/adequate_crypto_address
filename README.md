# AdequateCryptoAddress

[![Gem Version](https://badge.fury.io/rb/adequate_crypto_address.svg)](https://rubygems.org/gems/adequate_crypto_address)
[![Build Status](https://travis-ci.org/vtm9/adequate_crypto_address.svg?branch=master)](https://travis-ci.org/vtm9/adequate_crypto_address)
[![Code Climate](https://codeclimate.com/github/vtm9/adequate_crypto_address.svg)](https://codeclimate.com/github/vtm9/adequate_crypto_address)
[![Coverage Status](https://coveralls.io/repos/vtm9/adequate_crypto_address/badge.svg?branch=master)](https://coveralls.io/r/vtm9/adequate_crypto_address?branch=master)
[![License](https://img.shields.io/github/license/RubyMoney/money.svg)](https://opensource.org/licenses/MIT)




## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adequate_crypto_address'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adequate_crypto_address

## Usage

### Validation
``` ruby
require 'adequate_crypto_address'
# BTC
AdequateCryptoAddress.valid?('12QeMLzSrB8XH8FvEzPMVoRxVAzTr5XM2y', 'BTC') #=> true
AdequateCryptoAddress.valid?('3NJZLcZEEYBpxYEUGewU4knsQRn1WM5Fkt', :bitcoin, :p2sh) #=> true

# BCH
AdequateCryptoAddress.valid?('bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', :bch) #=> true
AdequateCryptoAddress.valid?('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD', :BCH, :P2PKHTestnet) #=> true
AdequateCryptoAddress.valid?('qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', :BCH, :bitcoincash) #=> true

# ETH
AdequateCryptoAddress.valid?('0xde709f2102306220921060314715629080e2fb77', :ETH) #=> true
AdequateCryptoAddress.valid?('de709f2102306220921060314715629080e2fb77', :ethereum) #=> true
```

### Normalization
``` ruby
require 'adequate_crypto_address'

# BCH
AdequateCryptoAddress.address('qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', 'bch').address #=> "bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk"
AdequateCryptoAddress.address('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD', 'bch').cash_address #=> "bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf"
AdequateCryptoAddress.address('bitcoincash:qrtj3rd8524cndt2eew3s6wljqggmne00sgh4kfypk', 'bch').legacy_address #=> "1LcerwTc1oPsMtByDCNUXFxReZpN1EXHoe"

# ETH
AdequateCryptoAddress.address('D1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb', 'eth').address #=> "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb"
```

## Development

Run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork [the repo](https://github.com/vtm9/adequate_crypto_address)
2. Grab dependencies: `bundle install`
3. Make sure everything is working: `bundle exec rake spec`
4. Make your changes
5. Test your changes
5. Create a Pull Request
6. Celebrate!!!!!

## Notes

Bug reports and pull requests are welcome on GitHub at https://github.com/vtm9/adequate_crypto_address/issues
