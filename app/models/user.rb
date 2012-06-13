class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :trackable, :validatable, :confirmable,
  # :lockable and :timeoutable 
  
  has_many :account_users, :dependent => :destroy, :include => [:roles,:account]
  has_many :accounts, :through => :account_users
  has_many :social_accounts, :dependent => :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # TODO: ALE - ERRO DO OMNIAUTH TAVA AQUI
  # :omniauthable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :locale, :name, :birthdate


  def has_social?
    !social_accounts.empty?
  end

  def find_or_create_social(auth)
    social_accounts.where("provider = ? AND social_id = ?", auth["provider"], auth["uid"]).first || create_social(auth)
  end

  def self.find_or_create_by_social(auth)
    unless user = SocialAccount.where("provider = ? AND social_id = ?", auth["provider"], auth["uid"]).first.try(:user)
      user = User.new
      if auth["extra"]["raw_info"]["email"]
        return false if !User.where(:email => auth["extra"]["raw_info"]["email"]).empty?
        user.email = auth["extra"]["raw_info"]["email"]
      end
      user.save(:validate => false)
      user.create_social(auth)
    end
    user
  end

  def create_social(auth)
    social_accounts.create! do |social_account|
      social_account.provider = auth["provider"]
      social_account.social_id = auth["uid"]
      social_account.token = auth["credentials"]["token"]
      social_account.user_id = self.id
    end
  end


  private

  def email_required?
    !has_social?
  end

end
