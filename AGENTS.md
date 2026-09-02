# Repository guide for coding agents

These instructions apply to the entire repository.

## Start here

- Read `README.md`, `mise.toml`, and the files relevant to the requested validator before editing.
- Preserve existing worktree changes. Do not discard, rewrite, or commit unrelated user work.
- Use the Ruby version pinned by mise. On macOS, plain `ruby` or `bundle` may resolve to the obsolete system Ruby.
- Run project commands through `mise run <task>` or one-off commands through `mise exec -- <command>`.

## Setup and canonical commands

```sh
mise trust
mise install
mise run setup
mise run test
mise run lint
mise run build
mise run check
mise run console
```

Review `mise.toml` before running `mise trust`; trust is required once per checkout in non-interactive environments.

`mise run check` is the required pre-handoff gate. It runs tests, lint, and the gem build in sequence.

## Project layout

- `lib/adequate_crypto_address.rb` is the public facade and loads every supported validator.
- `lib/adequate_crypto_address/<currency>.rb` contains currency-specific validation.
- `lib/adequate_crypto_address/utils/` contains shared encoding and checksum helpers.
- `spec/adequate_crypto_address_spec.rb` covers the public validation API.
- Focused utility specs live under paths matching their implementation, for example
  `spec/adequate_crypto_address/utils/bech32_spec.rb`.
- `adequate_crypto_address.gemspec` packages runtime files from `lib/`, `bin/`, the license, and the README;
  keep runtime additions inside those paths.

## Validator correctness rules

Address validation is security-sensitive. Avoid false positives and false negatives; never infer validity from
prefix or length alone when the protocol defines a checksum or binary structure.

- Base changes on authoritative protocol specifications and official test vectors.
- Add positive and negative vectors for every supported network, address type, and checksum variant affected.
- For Bitcoin-style witness addresses, witness v0 uses Bech32 and v1+ uses Bech32m.
- Cardano Shelley payment addresses use Bech32; pointer addresses contain exactly three structurally valid
  variable-length unsigned integers after the payment credential.
- Preserve the default two-element return value of `Utils::Bech32.decode`; callers that need the checksum
  variant must request `include_encoding: true`.
- Keep currency aliases, network/type behavior, `lib/adequate_crypto_address.rb` requires, and the README's
  supported-currency list synchronized.
- Do not bump the gem version unless the task explicitly includes preparing a release.

## Change discipline

- Prefer focused changes over unrelated cleanup. Existing RuboCop debt is recorded in `.rubocop_todo.yml`;
  do not broaden that baseline for new code.
- Put regression tests in the same change as a bug fix.
- Run `mise run check` and `git diff --check` before handoff.
- Do not publish gems, push branches, merge pull requests, or close issues unless explicitly requested.
