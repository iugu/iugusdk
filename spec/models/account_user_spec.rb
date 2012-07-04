require 'spec_helper'

describe AccountUser do
  before(:each) { @account_user = Fabricate(:account_user) }

  it { should have_many :roles }

  context "is? method" do
    before(:each) do
      @account_user.roles.destroy_all()
      @account_user.roles << Fabricate( :account_role, :name => "user", :account_user => @account_user )
    end

    it 'should return true when have the role' do
      @account_user.is?("user").should be_true
    end
    
    it 'should return false when dont have the role' do
      @account_user.is?("admin").should be_false
    end

    it 'should return true when have the role but searched with :param' do
      @account_user.is?(:user).should be_true
    end
  end

  context "is? method with different roles" do

    before(:each) do
      @account_user.roles.destroy_all()
    end

    context "when we have configured alias for roles" do
      # Stub CONSTANTS
      before(:all) do
        OLD_ROLES = APP_ROLES
        silence_warnings{ APP_ROLES = {"roles"=>["my_owner", "my_user"], "owner_role"=>"my_owner", "admin_role" => "my_user" } }
      end

      it "should find by the role when trying to check owner" do
        @account_user.roles << Fabricate(:account_role, :name => "my_owner", :account_user => @account_user)
        @account_user.is?("owner").should be_true
      end

      it "should find by the role when trying to check admin" do
        @account_user.roles << Fabricate(:account_role, :name =>"my_user", :account_user => @account_user )
        @account_user.is?( "admin" ).should be_true
      end

      after(:all) do
        silence_warnings{ APP_ROLES = OLD_ROLES }
      end
    end

  end

  context "set_roles method" do
    before(:all) do
      silence_warnings{ APP_ROLES = {"roles"=>["my_owner", "my_user", "my_guest"], "owner_role"=>"my_owner", "admin_role" => "my_user" } }
    end

    before(:each) do
      @account_user.roles.destroy_all
    end

    it 'should update roles' do
      @account_user.set_roles ["my_guest"]
      @account_user.is?("my_guest").should be_true
    end

    it 'should return true' do
      @account_user.set_roles(["my_user"]).should be_true
    end

    it 'should return false if receive an invalid role' do
      @account_user.set_roles(["invalid_role"]).should be_false
    end

    it 'should return true if receive nil' do
      @account_user.set_roles(nil).should be_true
    end

    it 'should destroy all roles if receive nil' do
      @account_user.set_roles(nil)
      @account_user.roles.empty?.should be_true
    end

    after(:all) do
      silence_warnings{ APP_ROLES = OLD_ROLES }
    end
  
  end

end
