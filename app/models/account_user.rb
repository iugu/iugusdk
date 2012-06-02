class AccountUser < ActiveRecord::Base
  has_many :account_roles, :dependent => :destroy
  belongs_to :user
  belongs_to :account

  after_create :add_default_roles

  # Write tests for this
  def add_default_roles
    account_roles.create( { :name => APP_ROLES[ "owner_role" ] } )
    account_roles.create( { :name => APP_ROLES[ "admin_role" ] } ) if APP_ROLES[ "owner_role" ] != APP_ROLES[ "admin_role" ]
  end

  def is?(role)
    role = APP_ROLES[ "owner_role" ] if role.to_s == "owner"
    role = APP_ROLES[ "admin_role" ] if role.to_s == "admin"
    account_roles.exists?(:name => role)
  end
end
