require 'spec_helper'

describe AccountUsersController do
  context "index" do
    login_as_user
    before(:each) do
      get :index, :account_id => @user.accounts.first.id
    end

    it { response.should render_template 'iugu/account_users/index' }
  
  end

  context "view" do
    login_as_user
    before(:each) do
      get :view, :account_id => @user.accounts.first.id, :user_id => @user.id
    end

    it { response.should render_template 'iugu/account_users/view' }
  
  end

end
