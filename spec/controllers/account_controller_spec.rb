require 'spec_helper'

describe AccountController do
  context "index" do
    login_as_user
    before do
      get :index
    end

    it { response.should render_template 'iugu/settings/account' }
  
  end
  
end
