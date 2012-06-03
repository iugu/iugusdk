require 'spec_helper'

describe  "new session requests" do
  before(:each) do
    Fabricate(:user) do
      email "teste@teste.teste"
      password "123456"
    end
    visit login_path
  end

  it { page.should have_content "Email" }
  it { page.should have_content "Password" }
  it { page.should have_content "Remember me" }
  it { page.should have_button "Sign in" }

  context "when loggin in" do

    before(:each) do
      fill_in 'Email', :with => "teste@teste.teste"
      fill_in 'Password', :with => "123456"
      click_button "Sign in"
    end

    # it { page.should have_content "teste@teste.teste" }
    # it { page.should have_link "Sign out" }
  
  end
end
