# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-09-02

This release hardens the validators against malformed input found in the
September 2026 security review. Several addresses that previous versions
incorrectly accepted are now rejected, and the public `address_type` API is
consistent across every currency. See the "Upgrading from 0.1.x to 0.2.0"
section of the README for migration guidance.

### Security

- **BCH legacy Base58Check** now verifies the four-byte double-SHA256 checksum
  and requires the exact 25-byte decoded length. One-character checksum
  mutations are rejected.
- **BCH CashAddr** now accepts only the `bitcoincash`, `bchtest`, and `bchreg`
  prefixes (an `evil:` prefix with a valid checksum is rejected) and validates
  the reserved bit, type bits, declared hash size, and decoded payload length
  (a shortened payload with a recomputed checksum is rejected).
- **TON** addresses are fully decoded: Base64URL payload, tag, workchain,
  32-byte account ID, CRC16-CCITT checksum, and testnet flag. Arbitrary
  48-character strings such as `"A" * 48` are no longer accepted.
- **Monero** is validated by decoding the Monero Base58 payload and checking the
  network byte, structural length, and Keccak-256 checksum for standard,
  integrated, and subaddress forms. Non-Base58 input such as `"4" + "!" * 94`
  is rejected.
- **Bounded input**: all validators enforce a practical length cap before
  Base58/Bech32 decoding, preventing pathological slowdowns on oversized input.
- Currency resolution now uses an explicit allowlist, so a `NoMethodError` from
  malformed input can no longer be misreported as `UnknownCurrency`.

### Added

- Public `AdequateCryptoAddress.address_type(address, currency)` with a
  consistent contract: it returns the detected type as a `Symbol` when the
  address is valid, or `nil` when it is not, for every supported currency.
- `Btc#network` and `Xmr#network` expose `:mainnet`/`:testnet`
  (`:stagenet` for Monero) so callers can enforce a network.
- `Toncoin` alias for the `Ton` validator.
- `bundler-audit` dependency advisory check, wired into `mise run check` and CI.
- Regression specs for checksum mutations, oversized input, nil input, invalid
  currency names, and the `address_type` contract across all currencies.

### Changed

- **Breaking:** `address_type` is now public on every validator and returns a
  type `Symbol` or `nil`. Previously it was private on most validators, returned
  `nil` for ETH/SOL/XLM, and required arguments on BCH.
- **Breaking:** TON's detected type changed from `:TON` to `:ton_mainnet` /
  `:ton_testnet`.
- **Breaking:** Monero's detected type is now `:standard`, `:integrated`, or
  `:subaddress` (was `:monero`).
- ETH now reports `address_type` `:eth`, SOL reports `:solana`, and XLM reports
  `:account` / `:muxed`.
- The BCH internal type-mapping helper was renamed from `address_type(code, type)`
  to `type_mapping(code, type)`.

### Documentation

- Documented supported per-currency types, the `address_type` API, network
  accessors, and an explicit "Format coverage" section listing address formats
  that are intentionally out of scope (and rejected rather than silently
  accepted).

[0.2.0]: https://github.com/vtm9/adequate_crypto_address/releases/tag/v0.2.0
