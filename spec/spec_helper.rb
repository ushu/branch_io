$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "simplecov"
require "rspec/simplecov"

SimpleCov.minimum_coverage 90
SimpleCov.start

require 'branch_io'

require "vcr"
VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.filter_sensitive_data("<BRANCH_KEY>") { ENV["BRANCH_KEY"] }
  config.filter_sensitive_data("<BRANCH_SECRET>") { ENV["BRANCH_SECRET"] }
  config.hook_into :webmock
end
