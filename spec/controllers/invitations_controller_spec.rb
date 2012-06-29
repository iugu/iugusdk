require 'spec_helper'

describe Iugu::InvitationsController do
  context "new" do
    login_as_user
    before(:each) do
      get :new
    end

    it { response.should render_template 'iugu/invitations/new' }
  
  end
end
