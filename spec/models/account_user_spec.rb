require 'spec_helper'

describe AccountUser do
  before(:each) { @account_user = Fabricate(:account_user) }

  it { should have_many :account_roles }

  context "is? method" do
    context "when has the role" do
    
      it 'should return true' do
        @account_user.account_roles << Fabricate(:account_role) { name "user" }
        @account_user.is?("user").should be_true
      end
    
    end

    context "when dont has the role" do
    
      it 'should return false' do
        @account_user.account_roles.destroy_all()
        @account_user.account_roles << Fabricate(:account_role) { name "user" }
        @account_user.is?("admin").should be_false
      end
    
    end


    context "when we use :name" do
    
      it 'should return true' do
        @account_user.account_roles << Fabricate(:account_role) { name "user" }
        @account_user.is?(:user).should be_true
      end
    
    end

    context "when we have configured alias for roles" do
      # Stub CONSTANTS
      before(:all) do
        OLD_ROLES = APP_ROLES
        silence_warnings{ APP_ROLES = {"roles"=>["my_owner", "my_user"], "owner_role"=>"my_owner", "admin_role" => "my_user" } }
      end

      it "should find by the role when trying to check owner" do
        @account_user.account_roles << Fabricate(:account_role) { name "my_owner" }
        @account_user.is?("owner").should be_true
      end

      it "should find by the role when trying to check admin" do
        @account_user.account_roles << Fabricate(:account_role) { name "my_user" }
        @account_user.is?( "admin" ).should be_true
      end

      after(:all) do
        silence_warnings{ APP_ROLES = OLD_ROLES }
      end
    end

  end

end
