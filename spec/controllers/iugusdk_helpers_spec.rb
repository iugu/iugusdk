require 'spec_helper'

# TODO: Refactor this test

class StubIuguHelpersController < SessionsController
  def test_current_user_account
 
    @current_user_account = current_user_account

    unless signed_in?
      render :text => "unauthorized", :status => 401
    else
      render :text => "Hello World", :status => 200
    end
  end
end

describe StubIuguHelpersController do

  include Devise::TestHelpers
  include Iugusdk::Controllers::Helpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "with a logged user" do
    before(:each) do
      @user = Fabricate(:user, :email => "me@me.com", :password => "123456", :password_confirmation => "123456" )
      @account = Fabricate(:account)
      @account.account_users << Fabricate(:account_user, :user => @user)
      with_routing do |map|
        map.draw do
          match '/stub/iugu/helpers/login' => "stub_iugu_helpers#create"
        end
        begin
          post :create, :user => { :email => "me@me.com", :password => "123456" }
        rescue
        end
      end
    end

    it "should be signed_in" do
      with_routing do |map|
        map.draw do
          match '/stub/iugu/helpers/index' => "stub_iugu_helpers#test_current_user_account"
          match '/stub/iugu/helpers/login' => "stub_iugu_helpers#create"
        end
        get :test_current_user_account
        response.code.should eq("200") 
      end
    end
  end

  context "with no logged user" do
    it "should not have a user account" do
      with_routing do |map|
        map.draw do
          match '/stub/iugu/helpers/index' => "stub_iugu_helpers#test_current_user_account"
          match '/stub/iugu/helpers/login' => "stub_iugu_helpers#create"
        end
        get :test_current_user_account
        response.code.should eq("401") 
      end
    end
  end

end
