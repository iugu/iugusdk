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
        }.should raise_error ActionController::RoutingError
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

    it 'should render new if create isnt successfull' do
      stub(UserInvitation).create {UserInvitation.new}
      post :create, :account_id => @account.id, :user_invitation => {:email => "create@controller.teste"}
      response.should render_template :new
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
      @user_invitation.account = @account
      @user_invitation.save
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

    context "when user is already member of the account" do
      before(:each) do
        @account.users << @user
        get :update, :invitation_token => @user_invitation.id.to_s + @user_invitation.token
      end
    
      it { response.should redirect_to root_path }

      it { flash.now[:notice].should == I18n.t("iugu.notices.you_are_already_member_of_this_account") }
    
    end
  end
end
