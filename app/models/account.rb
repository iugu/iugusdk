class Account < ActiveRecord::Base
  # Validators

  # Optional for now
  # validates :name, :presence => true

  has_many :account_users, :dependent => :destroy
  
end
