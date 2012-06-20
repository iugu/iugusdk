require 'spec_helper'

describe 'account settings view' do
  before(:each) do
    visit '/account/auth/facebook'
    visit account_settings_path
  end

  it { page.should have_content "Current User Account" }
  it { page.should have_content "Accounts" }
  it { page.should have_link I18n.t("iugu.remove") }

  context "when an account is being destroyed" do

    it 'should show an undo link if delay account exclusion > 0' do
      IuguSDK::delay_account_exclusion = 1
      click_on I18n.t("iugu.remove") 
      page.should have_link I18n.t("iugu.undo")
    end

    it 'should show Excluding.. if delay account exclusion = 0' do
      IuguSDK::delay_account_exclusion = 0
      click_on I18n.t("iugu.remove") 
      page.should have_content I18n.t("iugu.removing")
    end
  end

end
