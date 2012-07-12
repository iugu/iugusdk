require 'spec_helper'

describe Iugu::AccountUsersController do
  context "index" do
    login_as_user
    before(:each) do
      get :index, :account_id => @user.accounts.first.id
    end

    it { response.should render_template 'iugu/account_users/index' }
  
  end

  context "view" do
    login_as_user
    before(:each) do
      get :view, :account_id => @user.accounts.first.id, :user_id => @user.id
    end

    it { response.should render_template 'iugu/account_users/view' }
  
  end

  context "destroy" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
    end

    context "when current_user is account owner/admin" do

      before(:each) do
        @target_user = Fabricate(:user) do
          email 'target@teste.teste'
        end
        @account.account_users << @account_user = AccountUser.create(:user_id => @target_user.id)
      end

      it 'should raise routing error if account_id is invalid' do
        lambda {
          get :destroy, :account_id => 1892731892371273, :user_id => @target_user.id
        }.should raise_error ActionController::RoutingError
      end

      it 'should raise routing error if user_id is invalid' do
        lambda {
          get :destroy, :account_id => @account.id, :user_id => 18237198237192837
        }.should raise_error ActionController::RoutingError
      end

      context "and delete a non owner account" do
        before(:each) do
          @account_user.set_roles ["user"]
          get :destroy, :account_id => @account.id, :user_id => @target_user.id
        end

        it { response.should redirect_to account_users_index_path(@account.id) }
      
      end


      context "and dele an owner account" do
        before(:each) do
          @account_user.set_roles ["owner"]
        end

        it 'should raise routing error' do
          lambda {
            get :destroy, :account_id => @account.id, :user_id => @target_user.id
          }.should raise_error ActionController::RoutingError
        end
      
      end

      context "and try to delete itself from the account" do
        before(:each) do
          @account.account_users.find_by_user_id(@user.id).set_roles ["admin"]
        end

        it 'should raise routing error' do
          lambda {
            get :destroy, :account_id => @account.id, :user_id => @user.id
          }.should raise_error ActionController::RoutingError
        end
      
      end
       
    end
  
  end

  context "cancel_destruction" do
    login_as_user
    before(:each) do
      @account = @user.accounts.first
      @target_user = Fabricate(:user) do
        email 'target@test.test'
      end
      @account.account_users << @account_user = AccountUser.create(:user_id => @target_user.id)
      @account_user.set_roles ["user"]
      @account_user.destroy
    end

    it 'should raise routing error if account_id is invalid' do
      lambda {
        get :cancel_destruction, :account_id => 1892731892371273, :user_id => @target_user.id
      }.should raise_error ActionController::RoutingError
    end

    it 'should raise routing error if user_id is invalid' do
      lambda {
        get :cancel_destruction, :account_id => @account.id, :user_id => 18237198237192837
      }.should raise_error ActionController::RoutingError
    end
  
    context "when current user is owner/admin" do
      before(:each) do
        AccountUser.find_by_user_id_and_account_id(@user.id, @account.id).set_roles ["owner"]
        delete :cancel_destruction, :account_id => @account.id, :user_id => @target_user.id
      end

      it 'should cancel account_user destruction' do
        @account_user.destroying?.should be_false
      end

      it { response.should redirect_to account_users_index_path(@account.id) }
        
    end
    
    context "when current user is not owner/admin" do
      before(:each) do
        AccountUser.find_by_user_id_and_account_id(@user.id, @account.id).set_roles ["user"]
      end

      it 'should raise routing error' do
        lambda {
          delete :cancel_destruction, :account_id => @account.id, :user_id => @target_user.id
        }.should raise_error ActionController::RoutingError
      end
    end
  
  end

end
