require_relative '../../lib/registered_domains'
require_relative '../fixtures/registered_domains/namecheap'

include RegisteredDomains

describe Namecheap::Domains do
  let(:mock_ip) { '127.0.0.1' }

  let(:mock_domain) { ['fakedomain.fake'] }
  let(:mock_domains) { (1..101).map{|n| "fakedomain#{n}.fake"} }

  let(:namecheap_fixtures) { Fixtures::Namecheap.new }

  let(:namecheap_denied_response_body) do
    '{"message":"Permission Denied", "details":"IP address 127.0.0.1 is not on the whitelist for this account."}'
  end

  before do
    stub_request(:get, /ipv4.icanhazip.com/).
      to_return(status: 200, body: mock_ip, headers: {})
    stub_request(:get, /api.namecheap.com/).
      to_return(status: 200, body: namecheap_fixtures.single_page, headers: {})
  end

  it 'should return a single registered domain' do
    nc = Namecheap::Domains.new('fakeuser', 'fakeapikey', 'fakeapiuser')
    expect(nc.domains).to eq mock_domain
  end

  it 'should return a list of registered domains from multiple pages' do
    stub_request(:get, /api.namecheap.com.*Page=1/).
      to_return(status: 200, body: namecheap_fixtures.multi_page1, headers: {})
    stub_request(:get, /api.namecheap.com.*Page=2/).
      to_return(status: 200, body: namecheap_fixtures.multi_page2, headers: {})

    nc = Namecheap::Domains.new('fakeuser', 'fakeapikey', 'fakeapiuser')
    expect(nc.domains).to eq mock_domains
  end

  it 'should raise an error for invalid IP' do
    stub_request(:get, /api.namecheap.com/).
      to_return(status: 200, body: namecheap_fixtures.invalid_request_ip, headers: {})

    expect {Namecheap::Domains.new('fakeuser', 'fakeapikey', 'fakeapiuser')}.to raise_error(RuntimeError, 'Invalid request IP: 127.0.0.1')
  end
end
