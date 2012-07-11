require 'spec_helper'

describe Iugu::InvitationsController do
  context "before filter" do

    context "when user dont have permissions on account" do
      login_as_user
      before(:each) do
        @account = Fabricate(:account)
      end

      it 'should raise routing error' do
        lambda {
          get :new, :account_id => @account
        }.should raise_error
      end

    end
  
  end

  context "new" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      get :new, :account_id => @account.id
    end

    it { response.should render_template 'iugu/invitations/new' }
  
  end

  context "create" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      post :create, :account_id => @account.id, :user_invitation => {:email => "create@controller.teste"}
    end

    it { response.should redirect_to account_users_index_path(@account.id) }

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

      it 'should raise routing error' do
        lambda {
        put :edit, :invitation_token => "9821aaaaabbbbbaaaaaccccc"
        }.should raise_error ActionController::RoutingError
      end

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

    context "when token is not valid" do

      it 'should raise routing error' do
        lambda {
        put :update, :invitation_token => "9821aaaaabbbbbaaaaaccccc"
        }.should raise_error ActionController::RoutingError
      end

    end

    context "when token is valid" do
      before(:each) do
        get :update, :invitation_token => @user_invitation.id.to_s + @user_invitation.token
      end

      it { response.should redirect_to root_path }

    end
  end
end
