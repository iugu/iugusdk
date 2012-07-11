require 'spec_helper'

describe Iugu::AccountRolesController do

  context "edit" do
    login_as_user

    context "when current_user owns the account" do

      before(:each) do
        @current_account_user = @user.account_users.first
        @current_account_user.set_roles(["owner"])
        get :edit, :id => @current_account_user.account_id, :user_id => @current_account_user.user_id
      end

      it { response.should render_template "iugu/account_roles/edit" }
      it { response.should be_success }

    end

    context "when current_user do not owns the account" do

      before(:each) do
        @current_account_user = @user.account_users.first
        @current_account_user.set_roles(["user"])
        get :edit, :id => @current_account_user.account_id, :user_id => @current_account_user.user_id
      end

      it { response.should_not render_template "iugu/account_roles/edit" }
      it { response.should_not be_success }
    end
  
  end

  context "update" do
    login_as_user
    before(:each) do
      @account_id = @user.account_users.first.account_id
      post :update, :id => @account_id, :user_id => @user.id, :roles => []
    end
  
    it { response.should render_template "iugu/account_roles/edit" }
  
  end
  
end
