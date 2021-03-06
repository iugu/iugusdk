require 'spec_helper'

describe Iugu::AccountDomainsController do
  before(:each) do
    IuguSDK::enable_custom_domain = true
  end

  context "index" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      @account.account_domains << @domain = AccountDomain.create(:url => "controller.test.test")
      get :index, :account_id => @account.id
    end

    it { response.should render_template "iugu/account_domains/index" } 
  end

  context "create" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      post :create, :account_id => @account.id, :account_domain => { :url => "new.test.net" }
    end
  
    it { response.should redirect_to account_domains_instructions_path(@account.id, AccountDomain.last.id) } 

    context "without required fields" do
      before(:each) do
        post :create, :account_id => @account.id, :account_domain => {}
      end

      it { response.should render_template 'iugu/account_domains/index' }
    
    end
  end

  context "destroy" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      @account.account_domains << AccountDomain.create(:url => "destroy.test.net" )
      @domain = @account.account_domains.last
    end

    context "when using a valid id" do
      before(:each) do
        delete :destroy, :account_id => @account.id, :domain_id => @domain.id
      end

      it { response.should redirect_to account_domains_index_path(@account.id) } 

      it { flash.now[:notice].should == I18n.t("iugu.notices.domain_destroyed") }

    end
  
    context "when using an invalid id" do
      before(:each) do
        delete :destroy, :account_id => @account.id, :domain_id => 1273816283761238716
      end

      it { response.should redirect_to account_domains_index_path(@account.id) } 

      it { flash.now[:notice].should == I18n.t("iugu.notices.domain_not_found") }

    end
  end

  context "instructions" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      @account.account_domains << AccountDomain.create(:url => "instructions.test.net" )
      @domain = @account.account_domains.last
    end

    context "when using a valid id" do
      before(:each) do
        get :instructions, :account_id => @account.id, :domain_id => @domain.id
      end

      it { response.should render_template "iugu/account_domains/instructions" } 
    end

    context "when using an invalid id" do
      before(:each) do
        get :instructions, :account_id => @account.id, :domain_id => 1209371923812238
      end

      it { response.should redirect_to account_domains_index_path(@account.id) } 

      it { flash.now[:notice].should == I18n.t("iugu.notices.domain_not_found") }

    end
  end

  context "verify" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      @account.account_domains << AccountDomain.create(:url => "verify.test.net" )
      @domain = @account.account_domains.last
    end

    context "when using a valid id" do
    
      context "and domain is successfully verified" do
        before(:each) do
          stub.any_instance_of(AccountDomain).verify { true }
          get :verify, :account_id => @account.id, :domain_id => @domain.id
        end

        it { response.should redirect_to account_domains_index_path(@account.id) } 

        it { flash.now[:notice].should == I18n.t("iugu.notices.domain_verified") }

      end
  
      context "and domain could not be verified" do
        before(:each) do
          stub.any_instance_of(AccountDomain).verify { false }
          get :verify, :account_id => @account.id, :domain_id => @domain.id
        end

        it { response.should redirect_to account_domains_instructions_path(@account.id, @domain.id) } 

        it { flash.now[:notice].should == I18n.t("iugu.notices.domain_not_verified") }

      end
    end

    context "when receive an invalid id" do
      before(:each) do
        get :verify, :account_id => @account.id, :domain_id => 1231241241231241231234
      end
    
      it { response.should redirect_to account_domains_index_path(@account.id) } 

      it { flash.now[:notice].should == I18n.t("iugu.notices.domain_not_found") }
    
    end
  end

  context "primary" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      @account.account_domains << AccountDomain.create(:url => "primary.test.net" )
      @domain = @account.account_domains.last
    end

    context "when receive a valid id" do
      before(:each) do
        post :primary, :account_id => @account.id, :domain_id => @domain.id
      end

      it { response.should redirect_to account_domains_index_path(@account.id) } 

      it { flash.now[:notice].should == I18n.t("iugu.notices.domain_set_primary") }

    end
  
    context "when receive an invalid id" do
      before(:each) do
        post :primary, :account_id => @account.id, :domain_id => 1231241243141314
      end

      it { response.should redirect_to account_domains_index_path(@account.id) } 

      it { flash.now[:notice].should == I18n.t("iugu.notices.domain_not_found") }

    end
  
  end

  context "update_subdomain" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
    end

    context "when enable_account_alias == true" do
      before(:each) do
        IuguSDK::enable_account_alias = true
        put :update_subdomain, :account_id => @account.id, :account => {:subdomain => "subdomain"}
      end

      it { response.should redirect_to account_domains_index_path(@account.id) } 

      it { flash.now[:notice].should == I18n.t("iugu.notices.subdomain_updated") }

      context "and update isnt successfull" do
        before(:each) do
          stub.any_instance_of(Account).update_attributes { false }
          put :update_subdomain, :account_id => @account.id, :account => {:subdomain => "subdomain"}
        end

        it { response.should render_template :index }
    
      end
    end

    context "when enable_account_alias == false" do
      before(:each) do
        IuguSDK::enable_account_alias = false
      end

      it 'should raise RoutingError' do
        lambda { 
          put :update_subdomain, :account_id => @account.id, :account => {:subdomain => "subdomain"}
        }.should raise_error ActionController::RoutingError
      end
    end  
  end

  context "when enable_custom_domain == false" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      IuguSDK::enable_custom_domain = false
    end

    it 'create method should raise RoutingError' do
      lambda { 
        post :create, :account_id => @account.id, :account_domain => { :url => "new.test.net" }
      }.should raise_error ActionController::RoutingError
    end
    
    it 'destroy method should raise RoutingError' do
      lambda { 
        delete :destroy, :account_id => @account.id, :domain_id => 1
      }.should raise_error ActionController::RoutingError
    end
  
  end

  context "when enable_custom_domain == false && enable_account_alias == false" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      IuguSDK::enable_custom_domain = false
      IuguSDK::enable_account_alias = false
    end

    it 'index method should raise RoutingError' do
      lambda { 
        get :index, :account_id => @account.id
      }.should raise_error ActionController::RoutingError
    end
  
  end

end
