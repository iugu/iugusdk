IuguSDK
=========

Install
---------

**Add to your Gemfile**

    gem 'iugusdk'

**Config file**

config/initializers/iugusdk.rb

    IuguSDK.setup do |config|
      config.app_main_url = '/'
      config.application_title = 'example'
      #Add your other options
    end

More options
-----------

**enable_social_login**

  Enable login using facebook and twitter

**enable_social_linking**

  Allows users to link their facebook and twitter account to your application user

**enable_user_confirmation**

  Enables email confirmation on signup

**enable_email_reconfirmation**

  Enables email confirmation on user email change

**enable_guest_user**

  Enables login as guest user

**enable_user_api**

  Enables User api token

**enable_account_api**

  Enables Account api tokens

**account_api_tokens**

  Set available type of Account ApiTokens

  Example:
    
    config.account_api_tokens = [ 'test', 'admin', 'read-only' ]


