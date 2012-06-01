require 'spec_helper'

describe SessionsController do
  include Devise::TestHelpers

  before(:each) do
    @user = Fabricate(:user) do
      email "teste@teste.teste"
      password "123456"
    end
  end

  context "new action" do

    before(:each) do
      get 'new'
    end

    it { response.should render_template :new } 
  
  end

  context "create action" do
    
    before(:each) do
      sign_in @user
      post 'create'
    end

    it { response.should redirect_to root_path }

  end

  context "create action" do
    
    before(:each) do
      sign_in @user
      post 'destroy'
    end

    it { response.should redirect_to root_path }
  end
  
end
