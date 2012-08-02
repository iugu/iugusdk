require 'spec_helper'

describe "Settings requests" do
  context "settings layout" do
    before(:each) do
      visit '/account/auth/facebook'
    end

    context "when enable_multiple_accounts == false" do
      before(:each) do
        IuguSDK::enable_multiple_accounts = false
      end

      context "when user has only 1 account" do
        before(:each) do
          @user = User.last
          @user.accounts.destroy_all
          @user.accounts << Fabricate(:account)
          visit settings_path
        end

        it { page.should have_link I18n.t("iugu.account") }

      end

      context "when user has more than 1 account" do
        before(:each) do
          @user = User.last
          @user.accounts.destroy_all
          2.times { @user.accounts << Fabricate(:account) }
          visit settings_path
        end

        it { page.should have_link I18n.t("iugu.accounts") }

      end
    end


    context "when enable_multiple_accounts == true" do
      before(:each) do
        IuguSDK::enable_multiple_accounts = true
        visit settings_path
      end

      it { page.should have_link I18n.t("iugu.accounts") }

    end
  
    
  
  end
end
