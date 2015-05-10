require "webmock/rspec"
require "vcr"

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = "spec/cassettes"
  c.configure_rspec_metadata!
  c.hook_into :webmock
end
