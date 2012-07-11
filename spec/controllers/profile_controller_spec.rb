require 'spec_helper'

describe Iugu::ProfileController do

  context "index" do

    login_as_user

    before do
      get :index
    end

    it { response.should render_template 'iugu/settings/profile' }
  
  end

  context "update" do

    login_as_user

    before do
      post :update, :user => { :name => "Testname" }
    end

    it { response.should render_template 'iugu/settings/profile' }

     context "with errors" do
        login_as_user

        before do
          post :update, :user => { :password => "aaaaaaaaaaaaaa", :password_confirmation => "bbbbbbbbbbbbbb" }
        end

        it { flash[:error].should_not be_nil }
     
     end
  
  end

  context "destroy" do
    login_as_user

    before(:each) do
      get :destroy
    end

    it 'user should be destroyed' do
      @user.destroying?.should be_true
    end
  
  end

  context "cancel_destruction" do
    login_as_user

    before(:each) do
      @user.destroy
      get :cancel_destruction
    end

    it 'user destruction should be canceled' do
      @user.destroying?.should be_false
    end
  
  end

  context "destroy_social" do
    
    login_as_user

    before(:each) do
      @user.social_accounts << Fabricate(:social_account_without_user)
    end


    context "when user has email and password" do

      before do
        get :destroy_social, :id => @user.social_accounts.first.id
      end

      it { response.should redirect_to profile_settings_path }

      it 'should notice OK message' do
        flash.now[:notice].should match I18n.t("iugu.social_unlinked")
      end
    
    end

    context "when user has no email or password" do

      before do
        @user = Fabricate.build(:user_without_email)
        @user.social_accounts << Fabricate(:social_account_without_user)
        @user.skip_confirmation!
        @user.save(:validate => false)
        @user.reload
        sign_in @user
        get :destroy_social, :id => @user.social_accounts.first.id
      end

      it { response.should redirect_to profile_settings_path }

      it 'should notice no email/password error' do
        flash.now[:notice].should match I18n.t("errors.messages.only_social_and_no_email")
      end
    
    end

    context "when social_account id is wrong" do

      before do
        get :destroy_social, :id => 9128739127
      end

      it { response.should redirect_to profile_settings_path }

      it 'should notice record not found' do
        flash.now[:notice].should match I18n.t("errors.messages.not_found")
      end
    
    end
    
  end
end
