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

  
end
