class AccountRole < ActiveRecord::Base
  belongs_to :account_user
  validate :valid_role?

  validates_uniqueness_of :name, :scope => :account_user_id, :allow_nil => false
  validates_presence_of :account_user

  def self.roles
    APP_ROLES['roles']
  end

  private
  def valid_role?
    errors.add(:name, "Not a valid role") unless APP_ROLES['roles'].include? name
  end
end
