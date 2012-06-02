require 'spec_helper'

describe AccountRole do
  subject { Fabricate( :account_role ) }

  it { should belong_to :account_user }
  it { should validate_uniqueness_of(:name).scoped_to(:account_user_id) }
  it { should validate_presence_of(:account_user) }

  it 'should only accept configured roles' do
    role = Fabricate(:account_role)
    role.name = "not a role"
    role.should_not be_valid
  end

  it 'roles class method should return available roles' do
    AccountRole.roles.should == APP_ROLES['roles']
  end

end
