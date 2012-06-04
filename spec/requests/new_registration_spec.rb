require 'spec_helper'

describe "new registration requests" do

  before(:each) do
    @base_domain = "http://" + IuguSDK::application_main_host
    visit @base_domain + signup_path
  end

  it { page.should have_content "Email" }
  it { page.should have_content "Password" }
  it { page.should have_content "Password confirmation" }
  it { page.should have_button "Sign up" }
end
