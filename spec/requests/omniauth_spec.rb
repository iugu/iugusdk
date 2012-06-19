require 'spec_helper'

describe 'omniauth requests' do
  context "provider not found" do
    before(:each) do
      visit '/account/auth/orkut'
    end

    it { page.should have_content "Not found" }
  
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
    before(:each) do
      visit '/account/auth/twitter'
    end

    it { page.should have_content "signed in" }
  
    context "already signed in" do
      before(:each) do
        visit new_user_session_path 
        visit '/account/auth/twitter'
      end

      it { page.should have_content "UID" }
    
    end
  end
  
end
