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

  context "edit" do
    login_as_user
    before(:each) do
      @user_invitation = Fabricate(:user_invitation)
    end

    context "when token is valid" do
      before(:each) do
        get :edit, :invitation_token => "9821aaaaabbbbbaaaaaccccc"
      end

      it { response.should_not render_template "iugu/invitations/edit" }
    
    end

    context "when token is not valid" do
      before(:each) do
        get :edit, :invitation_token => @user_invitation.id.to_s + @user_invitation.token
      end
    
      it { response.should render_template "iugu/invitations/edit" }
    
    end
  
  end
end
