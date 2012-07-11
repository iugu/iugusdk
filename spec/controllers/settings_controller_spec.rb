require 'spec_helper'

describe Iugu::SettingsController do
  context "index" do
    login_as_user
    before do
      get :index
    end

    it { response.should redirect_to :profile_settings }
  
  end
  
end
