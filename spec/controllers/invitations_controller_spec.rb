require 'spec_helper'

describe Iugu::InvitationsController do
  context "new" do
    login_as_user
    before(:each) do
      @account = Fabricate(:account)
      get :new, :account_id => @account.id
    end

    it { response.should render_template 'iugu/invitations/new' }
  
  end

  context "create" do
    login_as_user
    before(:each) do
      @account = Fabricate(:account)
      post :create, :account_id => @account.id, :user_invitation => {:email => "create@controller.teste"}
    end

    it { response.should redirect_to :action => :new }

    it 'should create an invite' do
      UserInvitation.last.email.should == "create@controller.teste"
    end
  
  end

  context "edit" do
    login_as_user
    before(:each) do
      @user_invitation = Fabricate(:user_invitation)
      @user_invitation.update_attribute(:invited_by, @user.id)
    end

    context "when token is not valid" do
      before(:each) do
        get :edit, :invitation_token => "9821aaaaabbbbbaaaaaccccc"
      end

      it { response.should_not render_template "iugu/invitations/edit" }
    end

    context "when token is valid" do
      before(:each) do
        get :edit, :invitation_token => @user_invitation.id.to_s + @user_invitation.token
      end
    
      it { response.should render_template "iugu/invitations/edit" }
    
    end
  end

  context "update" do
    login_as_user
    before(:each) do
      @account = Fabricate(:account)
      @user_invitation = Fabricate(:user_invitation)
      @user_invitation.update_attribute(:account_id, @account.id)
    end

    context "when token is valid" do
      before(:each) do
        put :update, :invitation_token => "9821aaaaabbbbbaaaaaccccc"
      end

      it { response.should_not redirect_to root_path }
    end

    context "when token is valid" do
      before(:each) do
        get :update, :invitation_token => @user_invitation.id.to_s + @user_invitation.token
      end

      it { response.should redirect_to root_path }

    end
  end
end
