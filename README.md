IuguSDK
=========

Install
---------

**Add to your Gemfile**

    gem 'iugusdk'
    gem 'iugu-ux'

**Config file**

config/initializers/iugusdk.rb

    IuguSDK.setup do |config|
      config.app_main_url = '/'
      config.application_title = 'example'
      config.application_main_host = 'example.dev'
      config.application_main_host = 'example.com' if Rails.env.production?
      #Add your other options
    end

More options
-----------

**enable_social_login**

  Enable login using facebook and twitter

**enable_social_linking**

  Allows users to link their facebook and twitter account to your application user

**enable_guest_user**

  Enables login as guest user

**enable_user_confirmation**

  Enables email confirmation on signup

**enable_email_reconfirmation**

  Enables email confirmation on user email change

**enable_welcome_mail**

  Enables a Welcome email that is sent to User after registration

**enable_user_api**

  Enables User api token

**enable_account_api**

  Enables Account api tokens

**account_api_tokens**

  Set available types of Account ApiTokens

  Example:
    
    config.account_api_tokens = [ 'test', 'admin', 'read-only' ]

**delay_account_exclusion**

  Set a delay to account exclusion
  
  Examples:
  
    config.delay_account_exclusion = 30.minutes
    config.delay_account_exclusion = 5.days

**delay_user_exclusion**

  Set a delay to user exclusion
  
  Examples:
  
    config.delay_user = 30.minutes
    config.delay_user = 5.days


