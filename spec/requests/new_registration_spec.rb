require 'spec_helper'

describe "new registration requests" do

  before(:each) do
    visit '/signup'
  end

  it { page.should have_content "Email" }
  it { page.should have_content "Password" }
  it { page.should have_content "Password confirmation" }
  it { page.should have_button "Sign up" }
end
