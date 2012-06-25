require 'spec_helper'

describe 'account settings view' do
  before(:each) do
    visit '/account/auth/facebook'
    visit profile_settings_path
  end 

  it { page.should have_link I18n.t("iugu.remove_user") }

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

end
