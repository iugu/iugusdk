class Account < ActiveRecord::Base
  include ActiveUUID::UUID
  # Validators

  #TODO: Tirei o include porque dava pau no UUID
  #has_many :account_users, :dependent => :destroy, :include => [:roles,:account]
  has_many :account_users, :dependent => :destroy

  has_many :account_domains, :dependent => :destroy
  has_many :users, :through => :account_users
  has_many :tokens, :as => :tokenable, :class_name => "ApiToken"
  
  alias :_destroy :destroy
  def destroy
    Delayed::Job.enqueue DestroyAccountJob.new(id.to_s), :queue => "account_#{id}_destroy", :run_at => DateTime.now + IuguSDK::delay_account_exclusion
  end

  validates :subdomain, :uniqueness => true, :unless => Proc.new { |a| a.subdomain.blank? }
  validate :subdomain_blacklist, :name

  attr_accessible :subdomain, :name, :plan_identifier, :currency, :email
  attr_accessor :plan_identifier, :currency, :email

  after_create :set_first_subdomain, :unless => :subdomain?

  before_create :subscribe, if: Proc.new { IuguSDK::enable_subscription_features }

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
  
  private

  def subscribe
    customer = Iugu::Api::Customer.create email: email
    subscription = Iugu::Api::Subscription.create plan_identifier: plan_identifier, currency: currency, customer_id: customer.id.to_param
    self.subscription_id = subscription.id
    subscription.errors.empty?
  end

  def set_first_subdomain
    self.update_attribute(:subdomain, "#{IuguSDK::account_alias_prefix}#{id}")
  end

  def subdomain_blacklist
    if subdomain
      IuguSDK::custom_domain_invalid_prefixes.each do |invalid_prefix|
        errors.add(:subdomain, "Subdomain blacklisted") if subdomain == invalid_prefix
      end
    end
  end

end
