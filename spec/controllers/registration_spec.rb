require 'spec_helper'

describe RegistrationController do
  include Devise::TestHelpers

  context "action new" do

    before(:each) do
      get 'new'
    end

    it { response.should render_template 'new' }

    it 'should redirect_to main_app_url if user is already logged in' do
      @user = Fabricate(:user)
      sign_in @user
      get 'new'
      response.should redirect_to Iugusdk::app_main_url
    end
    
  end

  context "action create" do

    it "should create the user when data is right" do
      post 'create', :user => { :email => "teste@teste.teste", :password => "123456" }
      response.should redirect_to Iugusdk::app_main_url
    end

    it "should redirect to :new if cant create" do
      post 'create', :user => { :email => "testeteste", :password => "123456" }
      response.should render_template(:new)
    end
  end

end
