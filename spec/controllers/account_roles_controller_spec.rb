require 'spec_helper'

describe AccountRolesController do

  context "edit" do
    login_as_user
    before(:each) do
      @account = @user.account_users.first
      get :edit, :id => @account.id, :user_id => @user.id
    end

    it { response.should render_template "iugu/account_roles/edit" }
  
  end

  context "update" do
    login_as_user
    before(:each) do
      @account = @user.account_users.first
      post :update, :id => @account.id, :user_id => @user.id
    end
  
    it { response.should render_template "iugu/account_roles/update" }
  
  end
  
end
