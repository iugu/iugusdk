require 'spec_helper'

describe Account do
  before(:each) do
    IuguSDK::enable_account_api = true
    Fabricate(:account){ subdomain "unico" }
  end

  it { should have_many(:account_domains) }
  it { should have_many(:account_users) }
  it { should have_many(:users).through(:account_users) }
  it { should validate_uniqueness_of(:subdomain) }
  it { should validate_uniqueness_of(:api_token) }

  it "should return true for a valid user of account" do
    @user = Fabricate(:user, :email => "me@me.com")
    @account = Fabricate(:account)
    @account.account_users << Fabricate(:account_user, :user => @user)
    @account.valid_user_for_account?( @user ).should be_true
  end

  it 'should no accept subdomains in blacklist' do
    IuguSDK::custom_domain_invalid_prefixes = [ 'subdominio' ]
    @account = Fabricate.build(:account) { subdomain "subdominio" }.should_not be_valid
  end

  it 'should set api_token before create' do
    @account = Fabricate(:account)
    @account.api_token.should_not be_nil
  end

  it 'should_not set api_token before create if flag is false' do
    IuguSDK::enable_account_api = false
    @account = Fabricate(:account)
    @account.api_token.should be_nil
  end

  it 'should set subdomain before create' do
    @account = Fabricate(:account)
    @account.reload
    @account.subdomain.should_not be_nil
  end

  it 'should set subdomain as account_alias_prefix + id before create' do
    @account = Fabricate(:account)
    @account.reload
    @account.subdomain.should == "#{IuguSDK::account_alias_prefix}#{@account.id}"
  end

  context "destruction_job method" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should return a job' do
      @account.destroy
      @account.destruction_job.class.should == Delayed::Backend::ActiveRecord::Job 
    end
    
    it 'should return null if account has no destruction job' do
      @account.destruction_job.should be_nil
    end
  
  end

  context "destrying? method" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should return true if account has a destruction job' do
      @account.destroy
      @account.destroying?.should be_true
    end

    it 'should return false if account doesnt have a destruction job' do
      @account.destroying?.should be_false
    end
  end

  context "cancel_destruction" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should cancel account destruction' do
      @account.destroy
      @account.cancel_destruction
      @account.destroying?.should be_false
    end
    
    it 'should return a job' do
      @account.destroy
      @account.cancel_destruction.class.should == Delayed::Backend::ActiveRecord::Job
    end

    it 'should return nil if doesnt have a destruction job' do
      @account.cancel_destruction.should be_nil
    end

    it 'should return nil if destruction job is already locked' do
      @account.destroy
      @job = @account.destruction_job
      @job.locked_at = Time.now
      @job.save
      @account.cancel_destruction.should be_nil
    end

  end

  context "is? method" do
    before(:each) do
      @user = Fabricate(:user)
      @account = @user.accounts.first
      @account_user = @account.account_users.find_by_user_id(@user.id)
      @account_user.roles.destroy_all
      @account_user.roles << AccountRole.create(:name => "user")
    end 

    it 'should return true if user has the role for the account' do
      @account.is?(:user, @user).should be_true
    end 
  
    it 'should return if user hasnt the role for the account' do
      @account.is?(:admin, @user).should be_false
    end 
  
  end 

  context "name" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should return account name' do
      @account.name = "Named"
      @account.save
      @account.name.should == "Named"
    end

    it 'should return Account #ID if account name == nil' do
      @account.name = nil
      @account.save
      @account.name.should == "#{I18n.t("iugu.account")} ##{@account.id}"
    end
  
    it 'should return Account #ID if account name is blank' do
      @account.name = ""
      @account.save
      @account.name.should == "#{I18n.t("iugu.account")} ##{@account.id}"
    end

  end

  context "get_from_domain" do
    before(:each) do
      @account = Fabricate(:account) do
        subdomain "subdomainfind"
      end
      @account.account_domains << @domain = AccountDomain.create(:url => "getfromdomain.account.test")
      @domain.update_attribute(:verified, true)
    end

    it 'should return the account which owns the domain' do
      Account.get_from_domain("getfromdomain.account.test").should == @account
    end

    it 'should return the account which owns the subdomain' do
      Account.get_from_domain("subdomainfind.iugusdk.dev").should == @account
    end

    it 'should return nil ' do
      Account.get_from_domain("notused.domain.test").should be_nil
    end
  end

  context "generate_api_token" do
    before(:each) do
      @account = Fabricate(:account)
    end
    
    it 'should return a new token' do
      old_token = @account.api_token
      @account.send(:generate_api_token).should_not == old_token
    end

  end

  context "update_api_token" do
    before(:each) do
      @account = Fabricate(:account)
    end

    it 'should replace api_token' do
      old_token = @account.api_token
      @account.update_api_token
      @account.api_token.should_not == old_token
    end
  
  end
  

end
