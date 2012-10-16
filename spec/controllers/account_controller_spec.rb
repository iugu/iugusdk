require 'spec_helper'

describe Iugu::AccountController do
  context "index" do
    login_as_user
    before do
      get :index
    end

    it { response.should render_template 'iugu/settings/accounts' }
  
  end

  context "show" do

    context "with id param" do
      login_as_user
      before do
        get :view, :id => @user.accounts.first.id
      end

      it { response.should render_template 'iugu/settings/account' } 
    end

    context "without id param" do
      login_as_user
      before do
        get :view
      end

      it { response.should render_template 'iugu/settings/account' } 
    end
  
  end

  context "destroy" do
    login_as_user
    context "when enable_account_cancel == true" do
      context "and using right id" do
        before do
          IuguSDK::enable_account_cancel = true
          get :destroy, :id => @user.accounts.first.id
        end

        it { response.should redirect_to account_settings_path }

        it 'should start destruction job' do
          @user.accounts.first.destroying?.should be_true
        end
      end
    end

    context "when enable_account_cancel == false" do
      it 'should raise RoutingError' do
        IuguSDK::enable_account_cancel = false
        lambda{ get :destroy, :id => @user.accounts.first.id }.should raise_error ActionController::RoutingError
      end
    end

  end

  context "cancel_destruction" do
    login_as_user
    before do
      @user.accounts.first.destroy
    end

    context "when using right id" do
      before do
        get :cancel_destruction, :id => @user.accounts.first.id
      end

      it { response.should redirect_to account_settings_path }

      it 'should start destruction job' do
        @user.accounts.first.destroying?.should be_false
      end
    end

  end

  context "select" do
    login_as_user
    before do
      get :select, :id => @user.accounts.first.id
    end

    it { response.should redirect_to account_settings_path }

  end

  context "update" do
    login_as_user
    before(:each) do
      put :update, :id => @user.accounts.first.id, :account => { :name => "fudum" }
    end
  
    it { response.should redirect_to account_view_path(@user.accounts.first.id) }

    it { flash.now[:notice].should == I18n.t("iugu.notices.account_updated") }


    it 'should update account name' do
      @user.accounts.first.name.should == "fudum"
    end

  end

  context "create" do
    login_as_user
    before(:each) do
      post :create
    end

    it { response.should redirect_to account_settings_path }

    it 'should create an account to current_user' do
      lambda do
        post :create
      end.should change(@user.accounts, :count).by(1)
    end
  
  end

  context "generate_new_token" do
    login_as_user
    before(:each) do
      IuguSDK::enable_account_api = true
      @account = @user.accounts.last
      post :generate_new_token, :account_id => @account.id
    end

    it { response.should redirect_to account_view_path(@account.id) }

    it { flash.now[:notice].should == I18n.t("iugu.notices.new_token_generated") }

    context "when enable_account_api == false" do
      before(:each) do
        IuguSDK::enable_account_api = false
      end

      it 'should raise RoutingError' do
        lambda {
          post :generate_new_token, :account_id => @account.id
        }.should raise_error ActionController::RoutingError
      end

    end
  
  end
  
  
end
