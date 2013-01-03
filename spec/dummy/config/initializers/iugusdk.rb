IuguSDK.setup do |config|
  config.app_main_url = '/'
  config.app_root_url = '/'
  config.application_title = 'Dummy'
  config.enable_social_login = true
  config.enable_multiple_accounts = true
  config.enable_custom_domain = true
  config.enable_account_api = true
  config.enable_user_api = true
  config.enable_social_login = true
  config.enable_user_confirmation = true
  config.enable_email_reconfirmation = true
  config.enable_guest_user = true
  config.enable_multiple_users_per_account = true
  config.enable_welcome_mail = true
  config.iws_api_key = "e183c263d0108fe64fb372725bacab6d"

  config.delay_account_exclusion = 7
  config.delay_account_user_exclusion = 7
  config.delay_user_exclusion = 7

end
