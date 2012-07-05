require 'spec_helper'

describe "Account Users Requests" do
  before(:each) do
    visit '/account/auth/facebook'
  end

  context "index" do
    before(:each) do
      visit account_users_index_path(:account_id => User.last.accounts.first.id)
    end

    it { page.should have_content User.last.name }
    it { page.should have_link I18n.t("iugu.permissions") }
    it { page.should have_link I18n.t("iugu.remove") }
    it { page.should have_link I18n.t("iugu.invite") }
  
  end
end
