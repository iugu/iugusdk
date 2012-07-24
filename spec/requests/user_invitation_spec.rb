require 'spec_helper'

describe 'UserInvitations requests' do
  context "edit view" do
    before(:each) do
      visit '/account/auth/facebook'
      @inviter = Fabricate(:user) do
        name "fulano"
      end
      @account = Fabricate(:account)
      @user_invitation = Fabricate(:user_invitation)
      @user_invitation.account = @account
      @user_invitation.invited_by = @inviter.id
      @user_invitation.save
      visit edit_invite_path(@user_invitation.id.to_s + @user_invitation.token)
    end

    it { page.should have_content @inviter.name }
    it { page.should have_content @account.id }
    it { page.should have_link I18n.t("iugu.accept") }
  
  end

  context "new view" do
    before(:each) do
      visit'/account/auth/facebook'
      @user = User.last
      @account = @user.accounts.first
      visit new_invite_path(@account.id)
    end

    APP_ROLES['roles'].each do |role|
      it { page.should have_content role }
    end

    it { page.should have_content 'Email' }

    it { page.should have_button I18n.t("iugu.invite") }
  
  end
  
end
