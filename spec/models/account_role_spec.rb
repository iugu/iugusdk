require 'spec_helper'

describe AccountRole do
  subject {
    user = Fabricate( :user )
    user.account_users.first.roles.destroy_all
    @account_user = user.account_users.first
    Fabricate( :account_role, :account_user => @account_user )
  }

  it { should belong_to :account_user }
  it { should validate_uniqueness_of(:name).scoped_to(:account_user_id) }
  it { should validate_presence_of(:account_user) }

  it 'should only accept configured roles' do
    subject.name = "not a role"
    subject.should_not be_valid
  end

  it 'roles class method should return available roles' do
    AccountRole.roles.should == APP_ROLES['roles']
  end

end
