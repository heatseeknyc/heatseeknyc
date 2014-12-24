require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock
  c.default_cassette_options = { serialize_with: :json, record: :once }
  c.debug_logger = File.open(Rails.root.join('log', 'vcr.log'), 'a')
end