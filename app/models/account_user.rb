class AccountUser < ActiveRecord::Base
  has_many :account_roles
  belongs_to :user
  belongs_to :account

  def is?(role)
    role = APP_ROLES[ "owner_role" ] if role.to_s == "owner"
    role = APP_ROLES[ "admin_role" ] if role.to_s == "admin"
    account_roles.exists?(:name => role)
  end
end
