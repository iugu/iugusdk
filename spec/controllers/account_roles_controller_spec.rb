require 'spec_helper'

describe Iugu::AccountRolesController do

  context "edit" do
    login_as_user

    context "when current_user owns the account" do

      before(:each) do
        @current_account_user = @user.account_users.first
        @current_account_user.set_roles(["owner"])
        get :edit, :id => @current_account_user.account, :user_id => @current_account_user.user
      end

      it { response.should render_template "iugu/account_roles/edit" }
      it { response.should be_success }

    end

  end

  context "update" do
    login_as_user
    before(:each) do
      @account_id = @user.account_users.first.account
      post :update, :id => @account_id, :user_id => @user, :roles => []
    end
  
    it { response.should redirect_to account_users_index_path(@account_id)}
  
  end
  
end
