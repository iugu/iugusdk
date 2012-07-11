require 'spec_helper'

class StubAccountSettingsController < Iugu::AccountSettingsController

  def index
    render :text => "true", :status => 200
  end
  
end

describe StubAccountSettingsController do

  def with_stub_routing
    with_routing do |map|
      map.draw do
        match '/stub/account/settings/index' => "stub_account_settings#index"
      end
      yield
    end
  end

  before(:each) do
    @account = Fabricate(:account)
  end
  login_as_user

  it 'should render 404' do
    @account.destroy
    with_stub_routing do
      get :index, :account_id => @account.id
    end
    response.should_not be_success
  end

  it 'should not render 404' do
    with_stub_routing do
      get :index, :account_id => @account.id
    end
    response.should be_success
  end
  
end
