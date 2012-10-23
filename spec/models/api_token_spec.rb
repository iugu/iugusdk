require 'spec_helper'

describe ApiToken do
  before(:each) do
    IuguSDK::account_api_tokens = [ 'test', 'live' ]
    Fabricate(:api_token)
  end

  it { should validate_uniqueness_of(:token) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:tokenable) }

  it 'description should be unique for each tokenable record' do
    @acc = Fabricate(:account)
    @acc.tokens.create(description: "token 1", api_type: 'test').should be_valid
    @acc.tokens.create(description: "token 1", api_type: 'live').should_not be_valid
  end

  it 'api_type should be supported' do
    Fabricate.build(:api_token, api_type: 'not supported').should_not be_valid
  end
  
end
