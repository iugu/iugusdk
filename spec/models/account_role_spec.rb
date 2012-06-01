require 'spec_helper'

describe AccountRole do
  it { should belong_to :account_user }

  it 'should only accept configured roles' do
    role = Fabricate(:account_role)
    role.name = "not a role"
    role.should_not be_valid
  end

  it 'roles class method should return available roles' do
    AccountRole.roles.should == APP_ROLES['roles']
  end

end
