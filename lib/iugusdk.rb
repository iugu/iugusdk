require 'haml'
require 'haml-rails'
require 'simple_form'
require 'devise'
require "iugusdk/engine"

module Iugusdk

  mattr_accessor :app_root

  # Custom Variables Testing
  mattr_accessor :app_title

  mattr_accessor :no_signup_form
  mattr_accessor :app_main_url
  mattr_accessor :default_subscription_name
  mattr_accessor :guest_user_prefix
  mattr_accessor :multiple_accounts_per_user
  mattr_accessor :custom_domain_for_accounts

  self.no_signup_form = false
  self.app_main_url = '/'
  self.default_subscription_name = 'free'
  self.guest_user_prefix = 'appuser'
  self.multiple_accounts_per_user = false
  self.custom_domain_for_accounts = false

  def initialize
  end

  def self.setup
    yield self
  end

end
