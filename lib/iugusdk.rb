require 'haml'
require 'haml-rails'
require 'simple_form'
require 'iugusdk/controllers/helpers'
require 'iugusdk/valid_tenancy_urls'
require 'iugusdk/root_tenancy_url'
require "iugusdk/engine"
require "iugusdk/iugusdk_base_controller"
require "http_accept_language"
require 'devise'
require 'omniauth'
require 'omniauth-twitter'
require 'omniauth-facebook'
require 'delayed_job'
require 'delayed_job_active_record'
# TODO: ALE - Acho q vai precisar disto
# require 'oauth2'

module IuguSDK

  mattr_accessor :app_root

  mattr_accessor :application_title
  mattr_accessor :app_main_url
  mattr_accessor :app_root_url
  mattr_accessor :default_subscription_name
  mattr_accessor :guest_user_prefix
  mattr_accessor :default_layout
  mattr_accessor :alternative_layout

  mattr_accessor :enable_multiple_accounts
  self.enable_multiple_accounts = false

  mattr_accessor :application_main_host
  self.application_main_host = "iugusdk.dev"
  
  mattr_accessor :custom_domain_invalid_prefixes
  self.custom_domain_invalid_prefixes = ['www','blog','help','api']

  mattr_accessor :custom_domain_invalid_hosts
  self.custom_domain_invalid_hosts = ['localhost']

  mattr_accessor :delay_account_exclusion
  self.delay_account_exclusion = 0

  mattr_accessor :delay_account_user_exclusion
  self.delay_account_user_exclusion = 0
  
  mattr_accessor :delay_user_exclusion
  self.delay_user_exclusion = 0

  mattr_accessor :enable_account_alias
  self.enable_account_alias = false

  mattr_accessor :enable_custom_domain
  self.enable_custom_domain = false

  mattr_accessor :enable_account_api_token
  self.enable_account_api_token = false

  mattr_accessor :enable_social_login
  self.enable_social_login = false

  mattr_accessor :enable_social_linking
  self.enable_social_linking = false

  mattr_accessor :enable_user_confirmation
  self.enable_user_confirmation = false

  mattr_accessor :enable_email_reconfirmation
  self.enable_email_reconfirmation = false

  mattr_accessor :enable_subscription_features
  self.enable_subscription_features = false

  mattr_accessor :enable_signup_form
  self.enable_signup_form = true

  mattr_accessor :enable_guest_user
  self.enable_guest_user = false

  mattr_accessor :account_alias_prefix
  self.account_alias_prefix = 'account'

  mattr_accessor :enable_alias_on_signup
  self.enable_alias_on_signup = false

  self.application_title = 'Application Name'

  self.app_main_url = '/'
  self.app_root_url = '/'
  self.default_subscription_name = 'free'
  self.guest_user_prefix = 'appuser'

  self.default_layout = "settings"
  self.alternative_layout = "application"

  def initialize
  end

  def self.setup
    yield self
  end

end
