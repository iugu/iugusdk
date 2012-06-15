class Account < ActiveRecord::Base
  # Validators

  has_many :account_users, :dependent => :destroy, :include => [:roles,:account]
  has_many :users, :through => :account_users
  handle_asynchronously :destroy, :queue => Proc.new { |p| "account_#{p.id}_destroy" },
                        :run_at => Proc.new { DateTime.now + IuguSDK::delay_account_exclusion }
  

  def valid_user_for_account?( user )
    user = user.try(:id) if user.is_a? Object
    users.exists? user
  end

end
