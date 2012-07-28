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
      @account.users << Fabricate(:user, :email => "tester@roles.test")
      visit new_invite_path(:account_id => @account.id)
    end

    APP_ROLES['roles'].each do |role|
      it { page.should have_content role }
    end

    it { page.should have_content 'Email' }

    it { page.should have_button I18n.t("iugu.invite") }

    context "when current_user is owner" do
      before(:each) do
        @account_user = AccountUser.find_by_user_id_and_account_id(@user.id, @account.id)
        @account_user.set_roles ["owner"]
        visit new_invite_path(@account.id)
      end

      APP_ROLES['roles'].each do |role|
        it { page.should have_content role }
      end

    end
  
    context "when current_user is admin" do
      before(:each) do
        @account_user = AccountUser.find_by_user_id_and_account_id(@user.id, @account.id)
        @account_user.set_roles ["admin"]
        visit new_invite_path(@account.id)
      end

      APP_ROLES['roles'].each do |role|
        unless role == APP_ROLES['owner_role'] || role == APP_ROLES['admin_role']
          it { page.should have_content role }
        else
          it { page.should_not have_content role }
        end
      end

    end

  end
  
end
