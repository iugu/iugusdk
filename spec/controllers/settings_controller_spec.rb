require 'spec_helper'

# TODO: Refactor this test - (IT DOESNT DO NOTHING, NO LOGIN, ETC)

describe SettingsController do
  include Devise::TestHelpers

  context "with a user signed in" do
    before(:each) do
      @user = Fabricate(:user) do
        email "teste@teste.teste"
        password "123456"
      end
      sign_in @user
    end

    it "should be able to see /settings" do
      get 'index'
      response.should redirect_to profile_settings_path
    end
  end

  context "with no user signed in" do
    it "should not be able to see /settings" do
      get 'index'
      response.should_not be_success
      response.code.should eq("302")
    end
  end

end
