require 'webmock/rspec'

require 'simplecov'
SimpleCov.profiles.define 'no_vendor_coverage' do
  add_filter 'vendor' # Don't include vendored stuff
end

SimpleCov.start 'no_vendor_coverage'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'registered_domains'
