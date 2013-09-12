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
  validates :subdomain, subdomain: { reserved: IuguSDK::custom_domain_invalid_prefixes }, :unless => Proc.new { |a| a.subdomain.blank? }

  attr_accessible :subdomain, :name, :plan_identifier, :currency, :email
  attr_accessor :plan_identifier, :currency, :email

  after_create :set_first_subdomain, :unless => :subdomain?

  before_create :subscribe, if: Proc.new { IuguSDK::enable_subscription_features }

  after_destroy :remove_subscription, if: Proc.new { IuguSDK::enable_subscription_features }

  def self.get_from_domain(domain)
    AccountDomain.verified.find_by_url(domain).try(:account) || Account.find_by_subdomain(domain.gsub(".#{IuguSDK::application_main_host}","")) || (AccountDomain.verified.find_by_url(domain.gsub(".#{IuguSDK::application_main_host}","")).try(:account) if domain.match(".dev"))
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

  def subscription
    return nil unless subscription_id
    Iugu::Api::Subscription.find subscription_id.to_s.to_uuid.to_s
  end

  def cached_subscription_active?
    key = [self, "subscription_active?"]
    if Rails.cache.exist? key
      Rails.cache.read key
    else
      active = subscription_active?
      active ? time = 1.day : time = 5.minutes
      Rails.cache.write key, active, expires_in: time
      active
    end
  end

  def clear_cached_subscription_active
    Rails.cache.delete [self, "subscription_active?"]
  end

  def cached_subscription_features
    Rails.cache.fetch([self, "subscription_features"], expires_in: 1.day) { JSON.parse(subscription_features.to_json) || {} }
  end

  def clear_cached_subscription_features
    Rails.cache.delete [self, "subscription_features"]
  end

  def subscription_active?
    subscription.try :active 
  end

  def subscription_features
    subscription.try :features
  end

  def owner_account_user
    account_users.each { |au| return au if au.is? :owner }
    nil
  end

  def transfer_ownership(user)
    au = account_users.find_by_user_id user.id  
    au.set_owner

    owner_account_user.roles.find_by_name("owner").try :destroy if owner_account_user

    if au.is? :owner
      subscription = Iugu::Api::Subscription.find subscription_id.to_s.to_uuid.to_s
      customer = Iugu::Api::Customer.find subscription.customer_id
      customer.email = user.email
      customer.name = user.name
      customer.save
    end
  end

  def change_plan(identifier)
    sub = subscription
    return false unless sub
    if sub.change_plan(identifier)
      clear_cached_subscription_features
      return true
    end
    false
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

  def remove_subscription
    subscription.try :destroy
  end

end
