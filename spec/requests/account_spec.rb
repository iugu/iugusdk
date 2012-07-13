require 'spec_helper'

describe 'account settings view' do
  before(:each) do
    visit '/account/auth/facebook'
    visit account_settings_path
  end

  it { page.should have_link I18n.t("iugu.settings") }

  context "when allow_create_account == false" do
    before(:each) do
      IuguSDK::allow_create_account = false
    end

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

end
