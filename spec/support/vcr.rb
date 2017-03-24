require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock
  c.default_cassette_options = {
    serialize_with: :json,
    record: :once,
    allow_unused_http_interactions: false
  }
  c.debug_logger = File.open(Rails.root.join('log', 'vcr.log'), 'a')
  c.filter_sensitive_data('---WUNDERGROUND_KEY---') { ENV['WUNDERGROUND_KEY'] }
  c.filter_sensitive_data('---GEOCODE_API_KEY---') { ENV['GEOCODE_API_KEY'] }
  c.default_cassette_options = { match_requests_on: [:method, :host, :path, :query] }
  c.ignore_request do |r|
    r.uri.match(/api\.cityofnewyork\.us/) || r.uri.match(/maps\.googleapis\.com/)
  end
  c.configure_rspec_metadata!
end
