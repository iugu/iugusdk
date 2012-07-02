require 'spec_helper'

describe IuguMailer do
  before(:each) do
    @user_invitation = Fabricate(:user_invitation)
  end

  it 'should not raise an error' do
    lambda {IuguMailer.invitation(@user_invitation)}.should_not raise_error
  end

  context "rendered without error" do
    before(:each) do
      @mailer = IuguMailer.invitation(@user_invitation)
    end

    it 'should have a link to accept invite' do
      @mailer.body.should have_link edit_invite_path(:invitation_token => @user_invitation.id.to_s + @user_invitation.token)
    end
  
  end
end
