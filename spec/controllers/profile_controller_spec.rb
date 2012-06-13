require 'spec_helper'

describe ProfileController do
  include Devise::TestHelpers

  it_should_require_login_for_actions :index, :update

  describe "update action" do
    login_as_user
    before { post :update }
    it { should render_template 'iugu/profile_settings' }
  end

  context "with omniauth mockup for twitter" do
    context "already logged in" do
      before do
        env = {
          "omniauth.auth" => OmniAuth.config.mock_auth[:twitter]
        }
        @controller.stub!(:env).and_return env
      end
  
      login_as_user
  
      it "should link twitter into users account" do
        get :add_social
        response.should be_redirect
      end
  
      it "should unlink twitter off users account" do
        # TODO: Create this test
        get :add_social
        response.should be_redirect
        get :destroy_social, { :id => @user.social_accounts.first.id }
        response.should be_redirect
      end
    end

    context "not logged in" do
      before do
        env = {
          "omniauth.auth" => OmniAuth.config.mock_auth[:twitter]
        }
        @controller.stub!(:env).and_return env
      end

      it 'should redirect to root' do
        get :add_social
        response.should redirect_to '/'
      end
    end
  end

  context "with omniauth mockup for facebook" do
    context "already logged in" do
      before do
        env = {
          "omniauth.auth" => OmniAuth.config.mock_auth[:facebook]
        }
        @controller.stub!(:env).and_return env
      end
  
      login_as_user
      
      it "should link facebook into users account" do
        get :add_social
        response.should be_redirect
      end
    
      it "should unlink twitter off users account" do
        # TODO: Create this test
        get :add_social
        response.should be_redirect
        get :destroy_social, { :id => @user.social_accounts.first.id }
        response.should be_redirect
      end
    end

    context "not logged in" do
      before do
        env = {
          "omniauth.auth" => OmniAuth.config.mock_auth[:facebook]
        }
        @controller.stub!(:env).and_return env
      end
    
      it 'should redirect to root' do
        get :add_social
        response.should redirect_to '/'
      end
    end

    context "with an email already used" do
      before do
        env = {
          "omniauth.auth" => OmniAuth.config.mock_auth[:facebook]
        }
        @controller.stub!(:env).and_return env
        Fabricate(:user) do
          email env["omniauth.auth"]["extra"]["raw_info"]["email"]
        end
      end

      it 'should redirect to signup' do
        get :add_social
        response.should redirect_to signup_path
      end
    
    end
  end

end
