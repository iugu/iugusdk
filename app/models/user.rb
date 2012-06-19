class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :trackable, :validatable,
  # :lockable and :timeoutable 
  
  has_many :account_users, :dependent => :destroy, :include => [:roles,:account]
  has_many :accounts, :through => :account_users
  has_many :social_accounts, :dependent => :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :locale, :name, :birthdate

  after_create :create_account_for_user

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
      user.skip_confirmation!
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

  def devise_mailer
    IuguMailer
  end

  def accountable?
    !!!@skip_account_creation
  end

  def skip_create_account!
    @skip_account_creation = true
  end

  def default_account( account_id=nil )
    account_id = account_id.id if account_id.is_a? Account
    self.accounts.where( [ "accounts.id = ?", account_id] ).first || self.accounts.first
  end

  private

  def email_required?
    !has_social?
  end

  #def self.reconfirmable
  #  true
  #end

  @reconfirmable = true
  
  def create_account_for_user
    if accountable?
      new_account = Account.create({})
      account_user = new_account.account_users.create( { :user => self } )
    end
  end
end
