require 'spec_helper'

describe 'account settings view' do
  before(:each) do
    visit '/account/auth/facebook'
    visit account_settings_path
  end

  it { page.should have_content "Accounts" }
  it { page.should have_link I18n.t("iugu.remove") }

  context "when user dont own a account" do
    before(:each) do
      click_on "Sign out"
      user = User.last
      user.password = "123456"
      user.password_confirmation = "123456"
      user.save
      account_user = user.accounts.first.account_users.find_by_user_id(user.id)
      account_user.roles.destroy_all
      account_user.roles << AccountRole.new(:name => :user)
      visit new_user_session_path
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => "123456"
      click_on "Sign in"
      visit account_settings_path
    end
  
    it { page.should_not have_link I18n.t("iugu.remove") }
  
  end

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
