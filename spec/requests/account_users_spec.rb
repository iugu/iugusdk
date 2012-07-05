require 'spec_helper'

describe "Account Users Requests" do
  before(:each) do
    visit '/account/auth/facebook'
  end

  context "index" do

    context "when current_user is account owner" do

      before(:each) do
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
        @account_user = AccountUser.find_by_account_id_and_user_id(Account.last.id, User.last.id)
        @account_user.set_roles(["user"])
        visit account_users_index_path(:account_id => User.last.accounts.first.id)
      end

      it { page.should have_content User.last.name }
      it { page.should have_link I18n.t("iugu.remove") }
      it { page.should have_link I18n.t("iugu.invite") }
      it { page.should_not have_link I18n.t("iugu.permissions") }
    
    end
  
  end
end
