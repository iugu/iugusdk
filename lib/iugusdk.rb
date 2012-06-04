require 'haml'
require 'haml-rails'
require 'simple_form'
require 'devise'
require 'iugusdk/controllers/helpers'
require "iugusdk/engine"
require "http_accept_language"

module IuguSDK

  mattr_accessor :app_root

  mattr_accessor :application_title
  mattr_accessor :no_signup_form
  mattr_accessor :app_main_url
  mattr_accessor :app_root_url
  mattr_accessor :default_subscription_name
  mattr_accessor :guest_user_prefix
  mattr_accessor :multiple_accounts_per_user
  mattr_accessor :custom_domain_for_accounts
  mattr_accessor :default_layout

  self.application_title = 'Application Name'
  self.no_signup_form = false
  self.app_main_url = '/'
  self.app_root_url = '/'
  self.default_subscription_name = 'free'
  self.guest_user_prefix = 'appuser'
  self.multiple_accounts_per_user = false
  self.custom_domain_for_accounts = false

  self.default_layout = "settings"

  def initialize
  end

  def self.setup
    yield self
  end

end
