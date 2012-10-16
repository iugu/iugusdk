require 'spec_helper'

describe 'account settings view' do
  before(:each) do
    IuguSDK::enable_social_login = true
    IuguSDK::enable_social_linking = true
    IuguSDK::enable_user_cancel = true
    visit '/account/auth/facebook'
    visit profile_settings_path
  end 

  it { page.should have_content I18n.t("iugu.social_account") }

  context "when enable_user_cancel == true" do
    before(:each) do
      IuguSDK::enable_user_cancel = true
      visit profile_settings_path
    end 
    
    it { page.should have_link I18n.t("iugu.remove_user") }
  end

  context "when enable_user_cancel == false" do
    before(:each) do
      IuguSDK::enable_user_cancel = false
      visit profile_settings_path
    end 
    it { page.should_not have_link I18n.t("iugu.remove_user") }
  end

  context "when user is being destroyed" do
    before(:each) do
      click_on I18n.t("iugu.remove_user")
    end

    it { page.should have_content I18n.t("iugu.user_destruction_in") }
    it { page.should have_link I18n.t("iugu.undo") }
  
  end

  context "when user destruction job is locked" do
    before(:each) do
      User.last.destroy
      @job = User.last.destruction_job
      @job.locked_at = Time.now
      @job.save
      visit profile_settings_path
    end

    it { page.should_not have_link I18n.t("iugu.undo") }
  
  end

  context "when enable_social_linking == false" do
    before(:each) do
      IuguSDK::enable_social_linking = false
      visit profile_settings_path
    end

    it { page.should_not have_content I18n.t("iugu.social_account") }
  
  end

  context "when user is a guest" do
    before(:each) do
      IuguSDK::enable_guest_user = true
      visit root_path
      click_link I18n.t("iugu.sign_out")
      visit new_user_registration_path
      click_link I18n.t("iugu.try_first")
      visit profile_settings_path
    end

    it { page.should have_button I18n.t("iugu.become_user") } 
  
  end

end
