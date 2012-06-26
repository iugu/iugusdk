require 'spec_helper'

describe AccountController do
  context "index" do
    login_as_user
    before do
      get :index
    end

    it { response.should render_template 'iugu/settings/account' }
  
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

    context "when using right id" do
      before do
        get :destroy, :id => 31241
      end

      it { response.should redirect_to account_settings_path }

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

    end
  end

  context "select" do
    login_as_user
    before do
      get :select, :id => @user.accounts.first.id
    end

    it { response.should redirect_to account_settings_path }

  end
  
  
end
