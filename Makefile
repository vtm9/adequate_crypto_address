
GEM_VERSION := $(shell ruby -Ilib -radequate_crypto_address/version -e 'print AdequateCryptoAddress::VERSION')

build:
	gem build adequate_crypto_address.gemspec

push:
	gem push adequate_crypto_address-$(GEM_VERSION).gem
