require 'spec_helper'

describe 'account settings view' do
  before(:each) do
    visit '/account/auth/facebook'
    visit account_settings_path
  end

  it { page.should have_link I18n.t("iugu.remove") }
  it { page.should have_link I18n.t("iugu.users") }
  it { page.should have_link I18n.t("iugu.configs") }
  it { page.should have_link I18n.t("iugu.select") }

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

    it 'should not have users button' do
      click_on I18n.t("iugu.remove") 
      page.should_not have_link I18n.t("iugu.users") 
    end

    it 'should not have config button' do
      click_on I18n.t("iugu.remove") 
      page.should_not have_link I18n.t("iugu.configs") 
    end

    it 'should not have select account button' do
      click_on I18n.t("iugu.remove") 
      page.should_not have_link I18n.t("iugu.select_account") 
    end

  end


  context "when the accounts destruction job is locked" do
  
    before(:each) do
      IuguSDK::delay_account_exclusion = 1
      click_on "Sign out"
      user = User.last
      user.password = "123456"
      user.password_confirmation = "123456"
      account = user.accounts.first
      account.destroy
      job = account.destruction_job
      job.locked_at = Time.now
      job.save
      user.save
      visit new_user_session_path
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => "123456"
      click_on "Sign in"
      visit account_settings_path
    end

    it { page.should_not have_link I18n.t("iugu.undo") }
  
  end

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
    
    end

  
    
  
  end

end
