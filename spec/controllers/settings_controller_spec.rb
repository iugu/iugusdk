require 'spec_helper'

describe Iugu::SettingsController do
  context "index" do
    login_as_user
    before do
      get :index
    end

    it { response.should redirect_to :profile_settings }
  
  end
  
end

class StubPermissionsController < Iugu::SettingsController

  before_filter(:only => :stub){ |c| c.must_be [:owner, :admin], :id }
  before_filter(:only => :stub2){ |c| c.must_be :owner, :id }

  def stub
    render :text => "true", :status => 200
  end
  
  def stub2
    render :text => "true", :status => 200
  end

  
end

describe StubPermissionsController do

  def with_stub_routing
    with_routing do |map|
      map.draw do
        match '/stub/account/permissions/stub' => 'stub_permissions#stub'
        match '/stub/account/permissions/stub2' => 'stub_permissions#stub2'
      end
      yield
    end
  end

  login_as_user

  before(:each) do
    @user2 = Fabricate(:user, :email => "user2@email.email")
    @account = @user.accounts.first
    @account.users << @user2
    @account_user = AccountUser.find_by_user_id_and_account_id(@user.id, @account.id)
  end

  context "when user have permissions" do
    before(:each) do
      @account_user.set_roles [ "owner" ]
      with_stub_routing do
        get :stub, :id => @account.id
      end
    end

    it 'stub' do
      with_stub_routing do
        get :stub, :id => @account.id
      end
      response.should be_success
    end

    it 'should grant access to more than one role' do
      @account_user.set_roles [ "admin" ]
      with_stub_routing do
        get :stub, :id => @account.id
      end
      response.should be_success
    end

    it 'stub2' do
      with_stub_routing do
        get :stub2, :id => @account.id
      end
      response.should be_success
    end

  end

  context "when user dont have permissions" do
    before(:each) do
      @account_user.set_roles [ "user" ]
    end

    it 'stub should raise routing error' do
      lambda {
        with_stub_routing do
          get :stub, :id => @account.id
        end
      }.should raise_error ActionController::RoutingError
    end

    it 'stub2 should raise routing error' do
      @account_user.set_roles [ "admin" ]
      lambda {
        with_stub_routing do
          get :stub2, :id => @account.id
        end
      }.should raise_error ActionController::RoutingError
    end

  end

  context "when account user do not exist" do
    it 'should raise routing error' do
      lambda {
        with_stub_routing do
          get :stub, :id => 231213231231312312341
        end
      }.should raise_error ActionController::RoutingError
    end
  end
  
end
