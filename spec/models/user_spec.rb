require 'spec_helper'

describe User do

  subject{ Fabricate(:user) }

  it { should have_many(:account_users) }
  it { should have_many(:accounts).through(:account_users) }
  it { should have_many(:social_accounts) }
  it { should validate_presence_of(:email) }

  context "when enable_user_api = true" do
    before(:each) { IuguSDK::enable_user_api = true }

    it 'should have a token' do
      Fabricate(:user).token.should_not be_nil
    end

  end

  context "after create" do
    #it 'should create an account with subdomain' do
      #@user = Fabricate(:user) do
        #account_alias "alias"
      #end
      #@user.accounts.first.subdomain.should == "alias"
    #end

    it 'should send an email if enable_welcome_mail == true' do
      IuguSDK::enable_welcome_mail = true
      lambda{
        Fabricate(:user)
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  context "before_destroy" do
    before(:each) do
      @user = Fabricate(:user, :email => 'account1@before.destroy')
    end

    it 'should destroy private user accounts' do
      @account = @user.accounts.first
      @user.destroy
      @user.destruction_job.invoke_job
      @account.destroying?.should be_true
    end

    it 'should destroy private user accounts' do
      @user.accounts << Fabricate(:account)
      @account = @user.accounts.last
      @user.destroy
      @user.destruction_job.invoke_job
      @account.destroying?.should be_true
    end

    it 'should not destroy non-private accounts' do
      @account = @user.accounts.first
      @account.users << Fabricate(:user, :email => 'account2@before.destroy')
      @user.destroy
      @user.destruction_job.invoke_job
      @account.destroying?.should be_false
    end
  
  end

  it 'should not require email if guest == true' do
    Fabricate.build(:user) do
      email nil
      guest true
    end.should be_valid
  end

  context "become_user" do
    before(:each) do
      @user = User.create_guest
      @data = {:email => "regular@user.now", :password => "senhasecreta", :password_confirmation => "senhasecreta"}
    end

    it 'should return a regular user' do
      @user.become_user(@data).class.should == User
    end

    it 'should return false if email is invalid' do
      @data[:email] = "notvalid.email"
      @user.become_user(@data).should be_false
    end

    it 'should return false if user is not a guest' do
      @user.guest = false
      @user.save
      @user.become_user(@data).should be_false
    end
  
  end

  context "when enable_user_confirmation == false" do
    before(:each) do
      IuguSDK::enable_user_confirmation = false
    end

    it 'should skip confirmation' do
      @user = User.create(:email => "confirmation@skip.test", :password => "testtest", :password_confirmation => "testtest")
      @user.confirmed?.should be_true
    end
  end

  context "when enable_user_confirmation == true" do
    before(:each) do
      IuguSDK::enable_user_confirmation = true
    end

    it 'should not skip confirmation' do
      @user = User.create(:email => "confirmation@needed.test", :password => "testtest", :password_confirmation => "testtest")
      @user.confirmed?.should be_false
    end

  end

  context "when enable_email_reconfirmation == true" do
    before(:each) do
      IuguSDK::enable_email_reconfirmation = true
    end

    it 'should not skip email reconfirmation' do
      @user = User.create(:email => "reconfirmation@needed.test", :password => "testtest", :password_confirmation => "testtest")
      @user.email = "new@email.test"
      @user.save
      @user.email.should == "reconfirmation@needed.test"
    end
  end

  context "when enable_email_reconfirmation == false" do
    before(:each) do
      IuguSDK::enable_email_reconfirmation = false
    end

    it 'should skip email reconfirmation' do
      @user = User.create(:email => "reconfirmation@needed.test", :password => "testtest", :password_confirmation => "testtest")
      @user.email = "new@email.test"
      @user.save
      @user.email.should == "new@email.test"
    end
  end

  context "create_social" do
    before(:each) do
      @env = OmniAuth.config.mock_auth[:twitter]
      @user = Fabricate(:user)
    end

    it 'should create a social for the user' do
      @user.create_social(@env)
      @user.social_accounts.empty?.should be_false
    end
  end

  context "find_or_create_social" do
    before(:each) do
      @env = OmniAuth.config.mock_auth[:twitter]
      @user = Fabricate(:user)
    end

    it 'should return the social if find' do
      @user.create_social(@env)
      @sa = @user.find_or_create_social(@env)
      @sa.social_id.to_s.should == @env["uid"]
    end
  end

  context "find_or_create_by_social" do
    before(:each) do
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
    before(:each) do
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

  context "is? method" do
    before(:each) do
      @user = Fabricate(:user)
      @account = @user.accounts.first
      @account_user = @account.account_users.find_by_user_id(@user.id)
      @account_user.roles.destroy_all
      @account_user.roles << AccountRole.create(:name => "user")
    end

    it 'should return true if user has the role for the account' do
      @user.is?(:user, @account).should be_true
    end
  
    it 'should return if user hasnt the role for the account' do
      @user.is?(:admin, @account).should be_false
    end
    
  
  end

  context "create_guest method" do
    before(:each) do
      @user = User.create_guest("pt-BR")
    end

    it { @user.class.should == User }

    it { @user.email.should be_blank }
  
    it { @user.guest.should be_true }

    it { @user.name.should == "Guest" }
  
    it { @user.locale.should == "pt-BR" }

    it { @user.confirmed?.should be_true }

    it 'should create a destruction job' do
      lambda{
        User.create_guest
      }.should change(Delayed::Job, :count).by(1)
    end
    
  end


end
