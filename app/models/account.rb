class Account < ActiveRecord::Base
  # Validators

  has_many :account_users, :dependent => :destroy, :include => [:roles,:account]
  has_many :account_domains, :dependent => :destroy
  has_many :users, :through => :account_users
  handle_asynchronously :destroy, :queue => Proc.new { |p| "account_#{p.id}_destroy" },
                        :run_at => Proc.new { DateTime.now + IuguSDK::delay_account_exclusion }

  validates :subdomain, :uniqueness => true, :unless => Proc.new { |a| a.subdomain.blank? }
  validates :api_token, :uniqueness => true, :if => :api_token?
  validate :subdomain_blacklist

  before_create :set_first_token

  def self.get_from_domain(domain)
    AccountDomain.verified.find_by_url(domain).try(:account) || Account.find_by_subdomain(domain.gsub(".#{IuguSDK::application_main_host}",""))
  end
  

  def destruction_job
    Delayed::Job.find_by_queue("account_#{id}_destroy")
  end

  def destroying?
    !!destruction_job
  end

  def cancel_destruction
    destruction_job.try(:destroy) unless destruction_job.try(:locked_at)
  end

  def valid_user_for_account?( user )
    user = user.try(:id) if user.is_a? Object
    users.exists? user
  end

  def is?(role, user)
    account_users.find_by_user_id(user.id).is?(role.to_s)
  end

  def name
    (super.blank? ? "#{I18n.t('iugu.account')} ##{id}" : super)
  end
  
  def update_api_token
    self.update_attribute(:api_token, generate_api_token)
  end

  private

  def set_first_token
    self.api_token = generate_api_token
  end

  def generate_api_token
    Digest::MD5.hexdigest("#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")
  end

  def subdomain_blacklist
    if subdomain
      IuguSDK::custom_domain_invalid_prefixes.each do |invalid_prefix|
        errors.add(:subdomain, "Subdomain blacklisted") if subdomain == invalid_prefix
      end
    end
  end

end
