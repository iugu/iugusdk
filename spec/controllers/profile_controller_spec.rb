require 'spec_helper'

describe ProfileController do

  it_should_require_login_for_actions :index, :update

  describe "update action" do
    login_as_user
    before { post :update }
    it { should render_template 'iugu/profile_settings' }
  end


end
