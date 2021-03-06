require 'spec_helper'

describe 'omniauth requests' do
  before(:each) do
    IuguSDK::enable_social_login = true
    IuguSDK::enable_social_linking = true
  end
  context "provider not found" do
    before(:each) do
      visit '/account/auth/orkut'
    end

    it { page.should have_content "Not found" }
  
  end

  context "when not signed in" do
    context "and enable_social_login == false" do
      before(:each) do
        IuguSDK::enable_social_login = false
      end

      it 'should raise RoutingError' do
        lambda {
          visit '/account/auth/facebook'
        }.should raise_error ActionController::RoutingError
      end
    end
  end

  context "when signed in" do
    context "and enable_social_linking == false" do
      before(:each) do
        IuguSDK::enable_social_linking = false
        visit '/account/auth/facebook'
      end

      it 'should raise RoutingError' do
        lambda {
          visit '/account/auth/facebook'
        }.should raise_error ActionController::RoutingError
      end
    end
  end

  context "facebook" do
    context 'not signed in' do
      before(:each) do
        visit '/account/auth/facebook'
      end

      it { page.should have_content "signed in" }

    end
    
    context "already signed in" do
      before(:each) do
        visit new_user_session_path 
        Fabricate(:user, :email => 'test@test.test', :password => 'testing', :password_confirmation => 'testing')
        fill_in 'user_email', :with => "test@test.test"
        fill_in 'user_password', :with => "testing"
        click_on 'Sign in'
        visit '/account/auth/facebook'
        visit '/settings/profile'
      end

      it { page.should have_content "UID" }
    
    end

    context "with email already used" do
      before(:each) do
        email = OmniAuth.config.mock_auth[:facebook]["extra"]["raw_info"]["email"]
        Fabricate(:user, :email => email)
        visit '/account/auth/facebook'
      end
    
      it { page.should have_content I18n.t('errors.messages.email_already_in_use') }
    
    end
  
  end

  context "twitter" do

    context "not signed in" do

      before(:each) do
        visit '/account/auth/twitter'
      end
  
      it { page.should have_content "signed in" }
      
    end
  
    context "already signed in" do

      before(:each) do
        visit new_user_session_path 
        Fabricate(:user, :email => 'test@test.test', :password => 'testing', :password_confirmation => 'testing')
        fill_in 'user_email', :with => "test@test.test"
        fill_in 'user_password', :with => "testing"
        click_on 'Sign in'
        visit '/account/auth/twitter'
        visit '/settings/profile'
      end

      it { page.should have_content "UID" }
    
    end
  end
  
end
