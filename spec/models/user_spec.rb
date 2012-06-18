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

end
