class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :trackable, :validatable, :confirmable,
  # :lockable and :timeoutable 
  
  has_many :account_users, :dependent => :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me


  def email_required?
    true
  end
end
