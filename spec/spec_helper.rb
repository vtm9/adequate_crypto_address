# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'rspec'
require 'adequate_crypto_address'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.order = :random
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
