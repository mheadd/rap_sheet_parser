require "bundler/setup"
require 'active_model'
require 'ostruct'
require "rap_sheet_parser"

module RapSheetParser
  class ApplicationRecord
    def self.create!(params={})
      OpenStruct.new(params)
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
