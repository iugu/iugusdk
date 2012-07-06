require 'spec_helper'

describe UserInvitation do

  context "before save" do

    it 'should call set_token' do
      @user_invitation = UserInvitation.new(:email => "test@test.test")
      @user_invitation.should_receive :set_token
      @user_invitation.save
    end

    context "if has no token" do
      it 'should generate one' do
        @user_invitation = UserInvitation.new(:email => "test@test.test")
        @user_invitation.save
        @user_invitation.token.should_not be_nil
      end
    end

    context "if has a token" do
      it 'should not generate another token' do
        @user_invitation = UserInvitation.new(:email => "test@test.test", :token => "oiaa09s1jiUHAS8danja9sja0")
        @user_invitation.save
        @user_invitation.reload
        @user_invitation.token.should == "oiaa09s1jiUHAS8danja9sja0"
      end
    end
  end

  context "find by invitation_token" do
    before(:each) do
      @user_invitation = Fabricate(:user_invitation)
    end

    it 'should return an user invitation' do
      invitation_token = @user_invitation.id.to_s + @user_invitation.token
      UserInvitation.find_by_invitation_token(invitation_token).class.should == UserInvitation
    end

    it 'should return nil if token is invalid' do
      invitation_token = '12389as9sudasdjasd9uaaiushdas9d'
      UserInvitation.find_by_invitation_token(invitation_token).should be_nil
    end
  
  end

  context "accept" do
    before(:each) do
      @user_invitation = Fabricate(:user_invitation)
      @account = Fabricate(:account)
      @user = Fabricate(:user)
    end

    it 'should add user to account' do
      @user_invitation.account_id = @account.id
      @user_invitation.save
      @user_invitation.accept(@user)
      @account.account_users.find_by_user_id(@user.id).should_not be_nil
    end

    it 'should raise error when account_id is invalid' do
      @user_invitation.account_id = 2039812
      @user_invitation.save
      lambda { @user_invitation.accept(@user) }.should raise_error
    end

    it 'should save invite roles on account_user' do
      @user_invitation.account_id = @account.id
      @user_invitation.roles =(["user", "guest"].join(','))
      @user_invitation.save
      @user_invitation.accept(@user)
      AccountUser.last.is?('user').should be_true
    end
  end

  
end
