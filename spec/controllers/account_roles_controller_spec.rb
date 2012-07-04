require 'spec_helper'

describe AccountRolesController do

  context "edit" do
    login_as_user
    before(:each) do
      @account_id = @user.account_users.first.account_id
      get :edit, :id => @account_id, :user_id => @user.id
    end

    it { response.should render_template "iugu/account_roles/edit" }
  
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
