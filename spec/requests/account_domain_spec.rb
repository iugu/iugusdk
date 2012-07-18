require 'spec_helper'

describe "Account Domains requests" do
  context "index view" do
    before(:each) do
      visit "/account/auth/facebook"
      @user = User.last
      @account = Account.last
      @account.account_domains << @domain = Fabricate(:account_domain) { url "index.test.net" }
    end

    context "when domain is primary" do
      before(:each) do
        @domain.update_attribute(:primary, true)
        visit account_domains_index_path(@account.id)
      end

      it { page.should have_content I18n.t("iugu.primary") }

    end
  
    context "when domain is not primary" do
      before(:each) do
        @domain.update_attribute(:primary, false)
        visit account_domains_index_path(@account.id)
      end

      it { page.should have_link I18n.t("iugu.set_primary") }

    end
    
    context "when domain is verified" do
      before(:each) do
        @domain.update_attribute(:verified, true)
        visit account_domains_index_path(@account.id)
      end
      
      it { page.should have_content I18n.t("iugu.verified") }

    end
  
    context "when domain is not verified" do
      before(:each) do
        @domain.update_attribute(:verified, false)
        visit account_domains_index_path(@account.id)
      end

      it { page.should have_link I18n.t("iugu.instructions") }

    end

    context "when current_user is the owner of the account" do
      before(:each) do
        @account_user = AccountUser.find_by_user_id_and_account_id(@user.id, @account.id)
        @account_user.set_roles ["owner"]
        visit account_domains_index_path(@account.id)
      end

      it { page.should have_link I18n.t("iugu.remove") }

    end

    context "when current_user is not the owner of the account" do
      before(:each) do
        @account_user = AccountUser.find_by_user_id_and_account_id(@user.id, @account.id)
        @account_user.set_roles ["user"]
        visit account_domains_index_path(@account.id)
      end

      it { page.should_not have_link I18n.t("iugu.remove") }

    end

  end
  
end
