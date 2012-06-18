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

end
