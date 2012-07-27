require 'spec_helper'

describe 'accounts settings view' do
  before(:each) do
    visit '/account/auth/facebook'
    visit account_settings_path
    @user = User.last
    @account = Account.last
  end

  it { page.should have_link I18n.t("iugu.settings") }

  context "when allow_create_account == true" do
    before(:each) do
      IuguSDK::allow_create_account = true
      visit account_settings_path
    end

    it { page.should have_link I18n.t("iugu.create_account") }
  
  end

  context "when allow_create_account == false" do
    before(:each) do
      IuguSDK::allow_create_account = false
      visit account_settings_path
    end

    it { page.should_not have_link I18n.t("iugu.create_account") }

    context "and user has only one account" do
      before(:each) do
        @user = User.last
        @user.accounts.destroy_all
        @user.accounts << Fabricate(:account)
        visit account_settings_path
      end

      it { page.should have_content I18n.t("iugu.account") }
    
    end

    context "and user has more than one account" do
      before(:each) do
        @user = User.last
        @user.accounts.destroy_all
        2.times { @user.accounts << Fabricate(:account) }
        visit account_settings_path
      end

      it { page.should have_content I18n.t("iugu.accounts") }
      it { page.should have_link I18n.t("iugu.select") }
    
    end
  
  end

  context "Account view" do
    before(:each) do
      @user = User.last
      @user.accounts << @target_account = Fabricate(:account)
      @account_user = AccountUser.last
    end

    context "when current_user admin the account" do
      before(:each) do
        @account_user.set_roles ["admin"]
        visit account_view_path(@target_account.id)
      end

      it { page.should have_link I18n.t("iugu.manage") }

    end

    context "when current_user owns the account" do
      before(:each) do
        @account_user.set_roles ["owner"]
        visit account_view_path(@target_account.id)
      end
      it { page.should have_link I18n.t("iugu.manage") }

      it { page.should have_link I18n.t("iugu.cancel_account") }

      it { page.should have_content @target_account.api_token }
      
      it { page.should have_link I18n.t("iugu.generate_new_token") }

      context "when account is being canceled" do
        context "if delay_account_exclusion == 0" do
          before(:each) do
            IuguSDK::delay_account_exclusion = 0
            click_on I18n.t("iugu.cancel_account") 
            visit account_view_path(@target_account.id)
          end
          it { page.should have_content I18n.t("iugu.account_destruction_in") + @target_account.destruction_job.run_at.to_s }
        end

        context "if delay_account_exclusion > 0" do
          before(:each) do
            IuguSDK::delay_account_exclusion = 1
            click_on I18n.t("iugu.cancel_account") 
            visit account_view_path(@target_account.id)
          end
          it { page.should have_link I18n.t("iugu.undo") }
        end
      
      end

    end

  
    context "when current_user do not own the account" do
      before(:each) do
        @target_account.account_users << Fabricate(:account_user) { user Fabricate(:user) { email "notowner@account.test" } }
        @account_user.set_roles ["user"]
        visit account_view_path(@target_account.id)
      end

      it { page.should_not have_link I18n.t("iugu.manage") }

      it { page.should_not have_link I18n.t("iugu.cancel_account") }

      it { page.should_not have_content @target_account.api_token }

      it { page.should_not have_link I18n.t("iugu.generate_new_token") }

    end
    
  
  end
end
