require 'spec_helper'

describe SessionsController do

  before(:each) do
    @credentials = { :email => "teste@teste.com", :password => "123456" }
    @user = (Fabricate :user, @credentials)
  end

  context "new action" do
    before(:each) { get :new }
    it { should render_template('iugu/login') }
  end

  context "create action" do
    context "signing with a user" do
      before(:each) { post :create, :user => @credentials }

      it { should redirect_to IuguSDK::app_main_url }
    end
  end

  context "with a user logged in" do
    login_as_user

    context "should be able to logout" do
      before(:each) { post :destroy }
      it { should redirect_to IuguSDK::app_root_url }
    end
  end
  
end
