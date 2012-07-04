class AccountUser < ActiveRecord::Base
  has_many :roles, :class_name => "AccountRole", :dependent => :destroy
  belongs_to :user
  belongs_to :account

  after_create :add_default_roles

  validates_presence_of :user
  validates_presence_of :account

  # Write tests for this
  def add_default_roles
    roles.create( { :name => APP_ROLES[ "owner_role" ] } )
    roles.create( { :name => APP_ROLES[ "admin_role" ] } ) if APP_ROLES[ "owner_role" ] != APP_ROLES[ "admin_role" ]
  end

  def set_roles(new_roles)
    if new_roles.nil?
      roles.destroy_all
    else
      valid = true
      new_roles.each do |new_role|
        valid = false unless APP_ROLES['roles'].include? new_role
      end
      return false unless valid 
      roles.destroy_all
      new_roles.each do |new_role|
        roles.create( :name => new_role )
      end
    end
    true
  end

  def is?(role)
    role = APP_ROLES[ "owner_role" ] if role.to_s == "owner"
    role = APP_ROLES[ "admin_role" ] if role.to_s == "admin"
    roles.exists?(:name => role)
  end
end
