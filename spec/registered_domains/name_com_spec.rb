require_relative '../../lib/registered_domains'

include RegisteredDomains

describe NameCom::Domains do
  let(:mock_domains) { ['fakedomain.fake'] }

  let(:name_com_response_body) do
    '{"domains":[{"domainName":"fakedomain.fake","autorenewEnabled":true,"expireDate":"2020-04-09T00:00:00Z","createDate":"2012-04-13T02:54:14Z"}]}'
  end

  let(:name_com_denied_response_body) do
    '{"message":"Permission Denied", "details":"IP address 127.0.0.1 is not on the whitelist for this account."}'
  end

  let(:name_com_unauthenticated_response_body) do
    '{"message":"Unauthenticated"}'
  end

  before do
    stub_request(:get, /api.name.com/).
      to_return(status: 200, body: name_com_response_body, headers: {})
  end

  it 'should return a list of registered domains' do
    nc = NameCom::Domains.new('fakeuser', 'fakeapikey')

    expect(nc.domains).to eq mock_domains
  end

  it 'should raise an error when permission denied' do
    stub_request(:get, /api.name.com/).
      to_return(status: 403, body: name_com_denied_response_body, headers: {})

    expect{NameCom::Domains.new('fakeuser', 'fakeapikey')}.to raise_error(RuntimeError, 'Permission Denied: IP address 127.0.0.1 is not on the whitelist for this account.')
  end

  it 'should raise an error when unauthenticated' do
    stub_request(:get, /api.name.com/).
      to_return(status: 401, body: name_com_unauthenticated_response_body, headers: {})

    expect{NameCom::Domains.new('fakeuser', 'fakeapikey')}.to raise_error(RuntimeError, 'Failed to authenticate to https://api.name.com/v4/domains')
  end
end
