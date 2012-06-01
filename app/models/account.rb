class Account < ActiveRecord::Base
  # Validators

  validates :name, :presence => true
  
end
