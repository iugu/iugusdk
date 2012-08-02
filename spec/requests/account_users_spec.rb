require 'spec_helper'

describe "Account Users Requests" do
  before(:each) do
    IuguSDK::enable_social_login = true
    @user = Fabricate(:user)
    visit '/account/auth/facebook'
    @current_user = User.last
    @account = Account.last
  end

  context "index" do

    context "when current_user is account owner" do

      before(:each) do
        @account.account_users << AccountUser.create(:user_id => @user.id)
        @account.account_users.last.set_roles(["user"])
        @account_user = AccountUser.find_by_account_id_and_user_id(Account.last.id, User.last.id)
        @account_user.set_roles(["owner"])
        visit account_users_index_path(:account_id => User.last.accounts.first.id)
      end

      it { page.should have_content User.last.name }
      it { page.should have_link I18n.t("iugu.remove") }
      it { page.should have_link I18n.t("iugu.invite") }
      it { page.should have_link I18n.t("iugu.permissions") }

    end

    context "when current_user is account admin" do

      before(:each) do
        @account.account_users << AccountUser.create(:user_id => @user.id)
        @account.account_users.last.set_roles(["user"])
        @account_user = AccountUser.find_by_account_id_and_user_id(Account.last.id, User.last.id)
        @account_user.set_roles(["admin"])
        visit account_users_index_path(:account_id => User.last.accounts.first.id)
      end

      it { page.should have_content User.last.name }
      it { page.should have_link I18n.t("iugu.remove") }
      it { page.should have_link I18n.t("iugu.invite") }
      it { page.should have_link I18n.t("iugu.permissions") }

    end

    context "when current_user is not owner nor admin" do

      before(:each) do
        @account.account_users << Fabricate(:account_user) { user Fabricate(:user) { email "notowner@account.test" } }
        @account.account_users << AccountUser.create(:user_id => @user.id)
        @account.account_users.last.set_roles(["user"])
        @account_user = AccountUser.find_by_account_id_and_user_id(@account.id, @current_user.id)
        @account_user.set_roles(["user"])
        visit account_users_index_path(:account_id => @current_user.accounts.first.id)
      end

      it { page.should have_content User.last.name }
      it { page.should_not have_link I18n.t("iugu.remove") }
      it { page.should_not have_link I18n.t("iugu.invite") }
      it { page.should_not have_link I18n.t("iugu.permissions") }
    
    end
    
    context "when current_user and account_user are owners" do
      before(:each) do
        @account.account_users << AccountUser.create(:user_id => @user.id)
        @account.account_users.last.set_roles(["owner"])
        @account_user = AccountUser.find_by_account_id_and_user_id(Account.last.id, @current_user.id)
        @account_user.set_roles(["owner"])
        visit account_users_index_path(:account_id => @current_user.accounts.first.id)
      end

      it { page.should have_content User.last.name }
      it { page.should_not have_link I18n.t("iugu.remove") }
      it { page.should have_link I18n.t("iugu.invite") }
      it { page.should have_link I18n.t("iugu.permissions") }
    
    end

    context "when current_user is the only user of the account" do
      before(:each) do
        @account_user = AccountUser.find_by_account_id_and_user_id(Account.last.id, @current_user.id)
        @account_user.set_roles(["owner"])
        visit account_users_index_path(:account_id => @current_user.accounts.first.id)
      end

      it { page.should have_content User.last.name }
      it { page.should_not have_link I18n.t("iugu.remove") }
      it { page.should have_link I18n.t("iugu.invite") }
      it { page.should have_link I18n.t("iugu.permissions") }
    
    end
  
  end

  context "destroy" do
    before(:each) do
      @account.account_users << AccountUser.create(:user_id => @user.id)
      @account.account_users.last.set_roles(["user"])
      @account_user = AccountUser.find_by_account_id_and_user_id(Account.last.id, User.last.id)
      @account_user.set_roles(["owner"])
      visit account_users_index_path(:account_id => User.last.accounts.first.id)
    end
    
    context "when delay_account_user_exclusion == 0" do
      before(:each) do
        IuguSDK::delay_account_user_exclusion = 0
        click_on I18n.t("iugu.remove")
      end

      it { page.should have_content I18n.t("iugu.removing")  }
      it { page.should_not have_link I18n.t("iugu.undo") } 

    end
  
    context "when delay_account_user_exclusion > 0" do
      before(:each) do
        IuguSDK::delay_account_user_exclusion = 1
        click_on I18n.t("iugu.remove")
      end

      it { page.should_not have_content I18n.t("iugu.removing")  }
      it { page.should have_link I18n.t("iugu.undo") } 

    end
  
  end
end
