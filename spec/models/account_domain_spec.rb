require 'spec_helper'
describe AccountDomain do

  before(:each) do
    Fabricate(:account_domain)
  end

  it { should belong_to :account }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:account_id) }

  it 'should set primary as true if its the first domain of the account' do
    @account = Fabricate(:account)
    @account.account_domains << @domain = Fabricate(:account_domain) { url 'primary.test.test' }
    @domain.primary.should be_true
  end

  it 'should accept url with correct pattern' do
    @account = Fabricate(:account)
    @account.account_domains << @domain = Fabricate.build(:account_domain) do
      url 'valid.url.test'
    end
    @domain.valid?.should be_true
  end

  it 'should not accept url with incorrect pattern' do
    @account = Fabricate(:account)
    @account.account_domains << @domain = Fabricate.build(:account_domain) do
      url 'http://www.t3st.net'
    end
    @domain.valid?.should be_false
  end

  it 'should not accept url in the blacklist' do
    IuguSDK::custom_domain_invalid_hosts = ['invalid.domain.test']
    Fabricate.build(:account_domain) do
      url 'invalid.domain.test'
    end.should_not be_valid
  end

  context "normalize_host" do
    it 'should return normalized host' do
      @account_domain = Fabricate(:account_domain) do
        url "www.normal.host"
      end
      @account_domain.normalize_host.should == "normal.host"
    end
  end

  context "calculate_token" do
    it 'should return url token' do
      @account_domain = Fabricate(:account_domain) do
        url "www.normal.host"
      end
      @account_domain.calculate_token.class.should == String
    end
  end

  context "verify" do
    it 'should return true for valid url' do
      @account_domain = Fabricate(:account_domain) do
        url "www.test.net"
      end
      @account_domain.verify
      @account_domain.verified.should be_true
    end
  
    it 'should return false for invalid url' do
      @account_domain = Fabricate(:account_domain) do
        url "invalid.url.false"
      end
      @account_domain.verify
      @account_domain.verified.should be_false
    end

    it 'should unverify other domains with equal url' do
      @account_domain1 = Fabricate(:account_domain) do
        url "www.test.net"
      end
      @account_domain1.update_attribute(:verified, true)
      @account_domain2 = Fabricate(:account_domain) do
        url "www.test.net"
      end

      @account_domain2.verify

      @account_domain1.reload
      @account_domain1.verified.should be_false
    end
  
  end

  context "set_primary" do
    before(:each) do
      @account = Fabricate(:account)
      @account.account_domains <<  @domain1 = Fabricate(:account_domain) do
        url "www.url1.net"
        verified true
        primary true
      end
      @account.account_domains << @domain2 = Fabricate(:account_domain) do
        url "www.url2.net"
        verified true
        primary false
      end
      @domain1.account = @account
      @domain2.account = @account
      @domain1.save
      @domain2.save
    end

    it 'should make domain primary' do
      @domain2.set_primary
      @domain2.primary.should be_true
    end

    it 'should make other account domains not primary' do
      @domain2.set_primary
      @domain1.reload
      @domain1.primary.should be_false
    end
  
  end

end
