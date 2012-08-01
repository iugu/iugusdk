require 'spec_helper'

describe "Account Domains requests" do
  context "index view" do
    before(:each) do
      visit "/account/auth/facebook"
      @user = User.last
      @account = Account.last
      @account.account_domains << @domain = AccountDomain.create( url: "index.test.net" )
    end

    context "when enable_subdomain == true" do
      before(:each) do
        IuguSDK::enable_subdomain = true
        visit account_domains_index_path(@account.id)
      end

      it { page.should have_field 'account[subdomain]' }
    
    end

    context "when enable_subdomain == false" do
      before(:each) do
        IuguSDK::enable_custom_domain = true
        IuguSDK::enable_subdomain = false
        visit account_domains_index_path(@account.id)
      end

      it { page.should_not have_field 'account[subdomain]' }
    
    end

    context "when enable_custom_domain == true" do
      before(:each) do
        IuguSDK::enable_custom_domain = true
      end

      context "and domain is primary" do
        before(:each) do
          @domain.update_attribute(:primary, true)
          visit account_domains_index_path(@account.id)
        end

        it { page.should have_content I18n.t("iugu.primary") }
  
      end
  
      context "and domain is not primary" do
        before(:each) do
          @domain.update_attribute(:primary, false)
        end

        context "and domain is verified" do
          before(:each) do
            @domain.update_attribute(:verified, true)
            visit account_domains_index_path(@account.id)
          end

          it { page.should have_link I18n.t("iugu.set_primary") }
      
        end

        context "and domain is not verified" do
          before(:each) do
            @domain.update_attribute(:verified, false)
            visit account_domains_index_path(@account.id)
          end

          it { page.should_not have_link I18n.t("iugu.set_primary") }
      
        end

      end
    
      context "and domain is verified" do
        before(:each) do
          @domain.update_attribute(:verified, true)
          visit account_domains_index_path(@account.id)
        end
      
        it { page.should have_content I18n.t("iugu.verified") }

      end
  
      context "and domain is not verified" do
        before(:each) do
          @domain.update_attribute(:verified, false)
          visit account_domains_index_path(@account.id)
        end

        it { page.should have_link I18n.t("iugu.not_verified") }

      end

      context "and current_user is the owner of the account" do
        before(:each) do
          @account_user = AccountUser.find_by_user_id_and_account_id(@user.id, @account.id)
          @account_user.set_roles ["owner"]
          visit account_domains_index_path(@account.id)
        end
  
        it { page.should have_link I18n.t("iugu.remove") }
  
      end

    end

  end
  
end
