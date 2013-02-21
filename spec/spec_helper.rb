lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygems'
require 'intown'
require 'rspec'
require 'vcr'
require 'httparty'
require 'pry'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end
