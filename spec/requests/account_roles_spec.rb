require 'spec_helper'

describe 'Account Roles requests' do
  context "edit view" do
    before(:each) do
      visit '/account/auth/facebook'
      @user = User.last
      @account = @user.accounts.first
      @account_user =  @account.account_users.find_by_user_id(@user.id)
    end

    context "when current_user is account owner" do
      before(:each) do
        @account_user.set_roles [ "owner" ]
        visit account_roles_edit_path(:id => @account.id, :user_id => @user.id)
      end

      APP_ROLES['roles'].each do |role|
        it { page.should have_content role }
      end
    
    end
    
    context "when current_user is account admin" do
      before(:each) do
        @account.account_users << Fabricate(:account_user) { user Fabricate(:user) { email "notowner@account.test" } }
        @account_user.set_roles [ "admin" ]
        visit account_roles_edit_path(:id => @account.id, :user_id => @user.id)
      end
    
      APP_ROLES['roles'].each do |role|
        if role == APP_ROLES['owner_role'] || role == APP_ROLES['admin_role']
          it { page.should_not have_content role }
        else
          it { page.should have_content role }
        end
      end
      
    
    end
  
    
  
  end
end
