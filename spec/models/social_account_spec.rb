require 'spec_helper'

describe SocialAccount do
  it { should belong_to :user }

  it 'cant be destroyed if the user has no email and its the last social' do
    @user = Fabricate.build(:user_without_email)
    @user.password = "secret_password"
    @user.password_confirmation = "secret_password"
    @user.skip_confirmation!
    @user.save(:validate => false)
    @user.social_accounts << Fabricate(:social_account_without_user)
    User.find(@user.id).social_accounts.first.destroy.should be_false
    #@social_account.destroy.should be_false
  end

  it 'cant be destroyed if the user has no password and its the last social' do
    @social_account = Fabricate(:social_account)
    @user = @social_account.user
    @user.email = "testing@email.test"
    @user.password = ""
    @user.password_confirmation = ""
    @user.encrypted_password = ""
    @user.save(:validate => false)
    @social_account.destroy.should be_false
  end

  it 'can be destroyed if the user has email/password and its the last social' do
    @social_account = Fabricate(:social_account)
    @user = @social_account.user
    @user.email = "testing@email.test"
    @user.password = "12345678"
    @user.password_confirmation = "12345678"
    @user.save
    @social_account.destroy.should be_true
  end
end
