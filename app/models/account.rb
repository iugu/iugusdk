class Account < ActiveRecord::Base
  # Validators

  has_many :account_users, :dependent => :destroy, :include => [:roles,:account]
  has_many :users, :through => :account_users

  def valid_user_for_account?( user )
    user = user.try(:id) if user.is_a? Object
    users.exists? user
  end

end
