require 'spec_helper'

describe Iugu::InvitationsController do
  context "new" do
    login_as_user
    before(:each) do
      get :new
    end

    it { response.should render_template 'iugu/invitations/new' }
  
  end

  context "create" do
    login_as_user
    before(:each) do
      post :create, :user_invitation => {:email => "create@controller.teste"}
    end

    it { response.should redirect_to "new" }

    it 'should create an invite' do
      UserInvitation.last.email.should == "create@controller.teste"
    end
  
  end
end
