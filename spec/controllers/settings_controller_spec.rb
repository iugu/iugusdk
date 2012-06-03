require 'spec_helper'

describe SettingsController do

  context "with a user signed in" do
    login_as_user

    context "handle settings index logic" do
      before(:each) { get :index }
      it { should redirect_to profile_settings_path }
    end
  end

  it_should_require_login_for_actions :index

end
