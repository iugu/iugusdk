require 'spec_helper'

describe ProfileController do
  include Devise::TestHelpers

  it_should_require_login_for_actions :index, :update

  describe "update action" do
    login_as_user
    before { post :update }
    it { should render_template 'iugu/profile_settings' }
  end

  #describe "add_social action" do
    #login_as_user
    #before(:each) do
      #@request.env["omniauth.auth"] = 'uid'.stub!(:[]).and_return("1111")
      #get :add_social
    #end 
    #it { should redirect_to profile_settings_path }
  #end

end
