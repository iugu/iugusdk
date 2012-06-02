class AccountRole < ActiveRecord::Base
  belongs_to :account_user
  validate :valid_role?

  # TODO: Need to be unique per account_user_id ( account_user_id + name )

  def self.roles
    APP_ROLES['roles']
  end

  #def is_admin?
  #  name == APP_ROLES['admin_role']
  #end

  #def is_owner?
  #  name == APP_ROLES['owner_role']
  #end

  private
  def valid_role?
    errors.add(:name, "Not a valid role") unless APP_ROLES['roles'].include? name
  end
end
