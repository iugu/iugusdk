require 'spec_helper'

describe AccountController do

  it_should_require_login_for_actions :index

  context "index action" do
    login_as_user
    before { get :index }
    it { should render_template 'iugu/account_settings' }
  end


end
