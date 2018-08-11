# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'bundler/setup'
require 'concourse/github-team-resource'
require 'aruba/rspec'
require 'rspec/json_matcher'
require 'webmock/rspec'
require 'vcr'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RSpec::JsonMatcher
end

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.filter_sensitive_data('<REDACTED>') do
    ENV.fetch('GITHUB_TOKEN')
  end
end

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', name))
end
