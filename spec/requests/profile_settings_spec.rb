require 'spec_helper'

describe "Profile settings page" do
  before(:each) do
    @base_domain = "http://" + IuguSDK::application_main_host
    @user = Fabricate(:user) do
      email "teste@teste.teste"
      password "123456"
    end 
    visit @base_domain + login_path
    fill_in 'Email', :with => "teste@teste.teste"
    fill_in 'Password', :with => "123456"
    click_button "Sign in"

    visit @base_domain + profile_settings_path
  end

  it { page.should have_content "Name" }
  it { page.should have_content "Email" }
  it { page.should have_content "Birthdate" }
  it { page.should have_content "Locale" }
  it { page.should have_content "Password" }
  it { page.should have_content "Password confirmation" }

end
