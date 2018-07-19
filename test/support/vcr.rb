# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join 'test', 'vcr-cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
end
