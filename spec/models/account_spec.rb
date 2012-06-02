require 'spec_helper'

describe Account do

  it { should have_many(:account_users) }
  it { should have_many(:users).through(:account_users) }

  it "should return true for a valid user of account" do
    @user = Fabricate(:user, :email => "me@me.com")
    @account = Fabricate(:account)
    @account.account_users << Fabricate(:account_user, :user => @user)
    @account.valid_user_for_account?( @user ).should be_true
  end

end
