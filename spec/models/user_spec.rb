require 'spec_helper'

describe User do

  subject{ Fabricate(:user) }

  it { should have_many(:account_users) }
  it { should have_many(:accounts).through(:account_users) }
  it { should have_many(:social_accounts) }

  context "create_social" do
    before do
      @env = OmniAuth.config.mock_auth[:twitter]
      @user = Fabricate(:user)
    end

    it 'should create a social for the user' do
      @user.create_social(@env)
      @user.social_accounts.empty?.should be_false
    end
  end

  context "find_or_create_social" do
    before do
      @env = OmniAuth.config.mock_auth[:twitter]
      @user = Fabricate(:user)
    end

    it 'should call create_social if social not find' do
      @user.should_receive(:create_social)
      @user.find_or_create_social(@env)
    end

    it 'should return the social if find' do
      @user.create_social(@env)
      @sa = @user.find_or_create_social(@env)
      @sa.social_id.to_s.should == @env["uid"]
    end
  end

  context "find_or_create_by_social" do
    before do
      @env = OmniAuth.config.mock_auth[:twitter]
      @facebook = OmniAuth.config.mock_auth[:facebook]
    end

    it 'should create a new user with the social' do
      user = User.find_or_create_by_social(@env)
      user.social_accounts.first.social_id.to_s.should == @env["uid"]
    end

    it 'should create a new user' do
      user = User.find_or_create_by_social(@facebook)
      user.social_accounts.first.social_id.to_s.should == @facebook["uid"]
      user.email.should == @facebook["extra"]["raw_info"]["email"]
    end

    it 'should find user with social' do
      @user = Fabricate(:user)
      @user.create_social(@env)
      User.find_or_create_by_social(@env).should == @user
    end

    it 'should update socials token' do
      @user = Fabricate(:user)
      @social = @user.create_social(@env)
      @env['credentials']['token'] = "newtoken"
      @user = User.find_or_create_by_social(@env)
      @social.reload
      @social.token.should == "newtoken"
    end
      
  end

  context "create" do

    it 'should create an account for the user' do
      user = User.create(:email => "test@email.test", :password => "secretpassword", :password_confirmation => "secretpassword")
      user.accounts.empty?.should be_false
    end

    it 'should no create an account if skip_create_account!' do
      user = User.new(:email => "test@email.test", :password => "secretpassword", :password_confirmation => "secretpassword")
      user.skip_create_account!
      user.save
      user.accounts.empty?.should be_true
    end
  
  end

  context "default_account" do
    before do
      @user = Fabricate(:user)
    end

    it 'should return an account' do
      @user.default_account.class.should == Account
    end

    it 'should accept as account' do
      @user.default_account(@user.accounts.first).class.should == Account
    end

    it 'should accept as account id' do
      @user.default_account(@user.accounts.first.id).class.should == Account
    end
  
  end

  context "destruction_job method" do
    before(:each) do
      @user = Fabricate(:user)
    end 

    it 'should return a job' do
      @user.destroy
      @user.destruction_job.class.should == Delayed::Backend::ActiveRecord::Job 
    end 
    
    it 'should return null if account has no destruction job' do
      @user.destruction_job.should be_nil
    end 
  
  end 

  context "destrying? method" do
    before(:each) do
      @user = Fabricate(:user)
    end 

    it 'should return true if account has a destruction job' do
      @user.destroy
      @user.destroying?.should be_true
    end 

    it 'should return false if account doesnt have a destruction job' do
      @user.destroying?.should be_false
    end 
  end 

  context "cancel_destruction" do
    before(:each) do
      @user = Fabricate(:user)
    end 

    it 'should cancel account destruction' do
      @user.destroy
      @user.cancel_destruction
      @user.destroying?.should be_false
    end 
    
    it 'should return a job' do
      @user.destroy
      @user.cancel_destruction.class.should == Delayed::Backend::ActiveRecord::Job
    end 

    it 'should return nil if doesnt have a destruction job' do
      @user.cancel_destruction.should be_nil
    end 

    it 'should return nil if destruction job is locked' do
      @user.destroy
      job = @user.destruction_job
      job.locked_at = Time.now
      job.save
      @user.cancel_destruction.should be_nil
    end 
  
  end 


end
