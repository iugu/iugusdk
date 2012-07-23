class AccountRole < ActiveRecord::Base
  belongs_to :account_user
  validate :valid_role?

  validates_uniqueness_of :name, :scope => :account_user_id, :allow_nil => false
  validates_presence_of :account_user

  before_destroy do
    false if only_owner?
  end

  def self.roles
    APP_ROLES['roles']
  end

  private
  def valid_role?
    errors.add(:name, "errors.messages.invalid_role") unless APP_ROLES['roles'].include? name
  end

  def only_owner?
    self.name == APP_ROLES['owner_role'] && AccountRole.joins(:account_user).where('account_users.account_id = ? AND name = ?', account_user.account_id, :owner).count <= 1
  end
end
