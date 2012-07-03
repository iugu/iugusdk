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
      @user_invitation.update_attributes(:invited_by => @inviter.id, :account_id => @account.id)
      visit edit_invite_path(@user_invitation.id.to_s + @user_invitation.token)
    end

    it { page.should have_content @inviter.name }
    it { page.should have_content @account.id }
    it { page.should have_link I18n.t("iugu.accept") }
  
  end
  
end
