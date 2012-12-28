require 'spec_helper'

describe "Account Users Requests" do
  before(:each) do
    IuguSDK::enable_social_login = true
    IuguSDK::enable_multiple_users_per_account = true
    @user = Fabricate(:user)
    @account = @user.accounts.first
    @account_user = @user.account_users.first
    login_request @user
  end

  context "index" do

    context "when current_user role is" do
      before(:each) do
        @new_user = Fabricate(:user) { email "xpto@account.test" }
        @new_user_on_account = Fabricate(:account_user, user: @new_user)
        @account.account_users << @new_user_on_account

        @new_user_on_account.set_roles(["user"])
      end

      context do
        before(:each) do
          visit account_users_index_path(:account_id => @account)
        end

        context "owner" do

          it { page.should have_content @new_user.name }
          it { page.should have_link I18n.t("iugu.remove") }
          it { page.should have_link I18n.t("iugu.invite") }
          it { page.should have_link I18n.t("iugu.permissions") }

        end

        context "admin" do

          it { page.should have_content @new_user.name }
          it { page.should have_link I18n.t("iugu.remove") }
          it { page.should have_link I18n.t("iugu.invite") }
          it { page.should have_link I18n.t("iugu.permissions") }

        end

      end

      context "not owner nor admin" do

        before(:each) do
          @new_user_on_account.set_roles(["owner"])
          @account_user.set_roles(["user"])
          visit account_users_index_path(:account_id => @account)
        end

        it { page.should have_content @new_user.name }
        it { page.should_not have_link I18n.t("iugu.remove") }
        it { page.should_not have_link I18n.t("iugu.invite") }
        it { page.should_not have_link I18n.t("iugu.permissions") }

      end

      context "owner and account_user is also owner" do
        before(:each) do
          @new_user_on_account.set_roles(["owner"])
          visit account_users_index_path(:account_id => @account)
        end

        it { page.should have_content @new_user.name }
        it { page.should_not have_link I18n.t("iugu.remove") }
        it { page.should have_link I18n.t("iugu.invite") }
        it { page.should have_link I18n.t("iugu.permissions") }

      end

    end

    context "when current_user is the only user of the account" do
      before(:each) do
        visit account_users_index_path(:account_id => @account)
      end

      it { page.should have_content @user.name }
      it { page.should_not have_link I18n.t("iugu.remove") }
      it { page.should have_link I18n.t("iugu.invite") }
      it { page.should have_link I18n.t("iugu.permissions") }
    
    end
  
  end

  context "destroy" do
    before(:each) do
      @new_user = Fabricate(:user) { email "xpto@account.test" }
      @new_user_on_account = Fabricate(:account_user, user: @new_user)
      @account.account_users << @new_user_on_account

      @new_user_on_account.set_roles(["user"])
      visit account_users_index_path(:account_id => @account)
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
