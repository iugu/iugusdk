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
    context "when using right id" do
      before do
        get :destroy, :id => @user.accounts.first.id
      end

      it { response.should redirect_to account_settings_path }

      it 'should start destruction job' do
        @user.accounts.first.destroying?.should be_true
      end
    end

    context "when using wrong id" do
      before do
        get :destroy, :id => 31241
      end

      it { response.should redirect_to account_settings_path }

      it { flash.now[:notice].should == I18n.t("iugu.notices.account_not_found") }

    end

    context "when user is not the owner" do
      before(:each) do
        @account_user = @user.accounts.first.account_users.find_by_user_id(@user.id)
        @account = @user.accounts.first
        @account.account_users << Fabricate(:account_user) { user Fabricate(:user) { email "notowner@account.test" } }
        @account_user.roles.destroy_all
        @account_user.roles << AccountRole.create(:name => "user")
        get :destroy, :id => @user.accounts.first.id
      end

      it { response.should redirect_to account_settings_path }

      it 'should not destroy the account' do
        @user.accounts.first.destroying?.should be_false
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

    context "when using wrong id" do
      before do
        get :cancel_destruction, :id => 987213
      end

      it { response.should redirect_to account_settings_path }

      it { flash.now[:notice].should == I18n.t("iugu.notices.account_not_found") }

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

    it 'should raise error if receive an invalid id' do
      lambda {
        put :update, :id => 892738912731893719237, :account => { :name => "fudum" }
      }.should raise_error ActionController::RoutingError
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
      @account = @user.accounts.last
      post :generate_new_token, :account_id => @account.id
    end

    it { response.should redirect_to account_view_path(@account.id) }

    it { flash.now[:notice].should == I18n.t("iugu.notices.new_token_generated") }
  
  end
  
  
end
