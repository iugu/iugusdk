class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :trackable, :validatable,
  # :lockable and :timeoutable 
  
  has_many :account_users, :dependent => :destroy, :include => [:roles,:account]
  has_many :accounts, :through => :account_users
  has_many :social_accounts, :dependent => :destroy

  handle_asynchronously :destroy, :queue => Proc.new { |p| "user_#{p.id}_destroy" },
                        :run_at => Proc.new { DateTime.now + IuguSDK::delay_user_exclusion }

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :locale, :name, :birthdate, :guest, :account_alias

  mattr_accessor :account_alias
  
  before_destroy :destroy_private_accounts

  before_create :skip_confirmation!, :unless => Proc.new { IuguSDK::enable_user_confirmation }

  after_create :create_account_for_user

  after_create :send_welcome_mail, :if => Proc.new { |r| IuguSDK::enable_welcome_mail && !r.email.blank? }

  before_save :skip_reconfirmation!, :unless => Proc.new { IuguSDK::enable_email_reconfirmation }

  validates :email, :email => true, :unless => :guest?
  validates :locale, :presence => true

  default_value_for :locale, AvailableLanguage.default_locale

  def destruction_job
    Delayed::Job.find_by_queue("user_#{id}_destroy")
  end

  def destroying?
    !!destruction_job
  end

  def cancel_destruction
    destruction_job.try(:destroy) unless destruction_job.try(:locked_at)
  end

  def is?(role, account)
    account.account_users.find_by_user_id(self.id).is?(role.to_s)
  end

  def has_social?
    !social_accounts.empty?
  end

  def find_or_create_social(auth)
    social_accounts.where("provider = ? AND social_id = ?", auth["provider"], auth["uid"]).first || create_social(auth)
  end

  def self.create_guest(locale = "en")
    user = User.new({
      :guest => true,
      :name => "Guest",
      :locale => locale
    })
    user.skip_confirmation!
    user.save(:validate => false)
    user.delay(:run_at => DateTime.now + IuguSDK::destroy_guest_in, :queue => "guest_#{user.id}").destroy
    user
  end

  def self.find_or_create_by_social(auth)
    social_account = SocialAccount.where("provider = ? AND social_id = ?", auth["provider"], auth["uid"]).first
    unless user = social_account.try(:user)
      user = User.new
      if auth["extra"]["raw_info"]["email"]
        return false if !User.where(:email => auth["extra"]["raw_info"]["email"]).empty?
        user.email = auth["extra"]["raw_info"]["email"]
      end
      user.birthdate = Date.strptime(auth["extra"]["raw_info"]["birthday"], '%m/%d/%Y') if auth["extra"]["raw_info"]["birthday"]
      user.locale = AvailableLanguage.best_locale_for(auth["extra"]["raw_info"]["locale"]) if auth["extra"]["raw_info"]["locale"]
      user.locale = AvailableLanguage.best_locale_for(auth["extra"]["raw_info"]["lang"]) if auth["extra"]["raw_info"]["lang"]
      user.skip_confirmation!
      user.save(:validate => false)
      social_account = user.create_social(auth)
    end
    social_account.update_attribute( 'token' , auth['credentials']['token'] )
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

  def become_user(data)
    if self.guest
      self.guest = false
      self.email = data[:email]
      self.password = data[:password]
      self.password_confirmation = data[:password_confirmation]
      if self.save
        Delayed::Job.find_by_queue("guest_#{id}").destroy
        self
      else
        self.guest = true
        false
      end
    else
      false
    end
  end

  private

  def destroy_private_accounts
    self.accounts.each do |acc|
      acc.destroy if acc.account_users.count <= 1
    end
  end

  def email_required?
    !(has_social? || guest?)
  end

  def send_welcome_mail
    IuguMailer.welcome(self).deliver
  end


  #def self.reconfirmable
  #  true
  #end

  @reconfirmable = true
  
  def create_account_for_user
    if accountable?
      new_account = Account.create( :subdomain => account_alias )
      account_user = new_account.account_users.create( { :user => self } )
    end
  end
end
