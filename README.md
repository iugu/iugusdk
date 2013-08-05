IuguSDK
=========

Getting Started
------------

- **Create your Ruby on Rails 3.2.14 Project**

        rails _3.2.14_ new myapp_name -d mysql
        cd myapp_name

- **Add to your Gemfile**
  
  ```ruby
  gem 'iugusdk'
  ```

- **Run IuguSDK config**

        rails g iugusdk_config myapp_name

- **Features**

  Features can be enable by editing iugusdk initializer

  Example:

  config/initializer/iugusdk.rb

  ```ruby
  IuguSDK.setup do |config|
    #...

    #Enabling user api
    config.enable_user_api = true

    #...
  end
  ```

- **Runnning delayed jobs**

        bundle exec rake jobs:work

  This is needed for delay exclusion features


Social Network Integration
-----------

**Features**

- enable_social_login

- enable_social_linking

**Config Credentials**

config/social_accounts.yml

    facebook:
      token: 'yourtoken'
      secret: 'yoursecret'
      scope: 'user_birthday'
    twitter:
      token: 'yourtoken'
      secret: 'yoursecret'
      scope: 

Api Options
------------

**Features**

- enable_user_api

  Enables User api token

- enable_account_api

  Enables Account api tokens

- account_api_tokens

  Set available types of Account ApiTokens

  Example:

  ```ruby
  config.account_api_tokens = [ 'test', 'admin', 'read-only' ]
  ```

Account and User Exclusion Options
------------------

**Features**

- enable_account_cancel

  Enables account exclusion (enabled by default)

- enable_user_cancel

  Enables user exclusion (enabled by default)

- delay_account_exclusion

  Set a delay to account exclusion
  
  Examples:

  ```ruby  
  config.delay_account_exclusion = 30.minutes
  config.delay_account_exclusion = 5.days
  ```

- delay_user_exclusion

  Set a delay to user exclusion
  
  Examples:
  
  ```ruby
  config.delay_user = 30.minutes
  config.delay_user = 5.days
  ```

Web-App
----------

**Generate Structure"

    rails g webapp


Other Features
-----------

- enable_guest_user

  Enables login as guest user

- enable_user_confirmation

  Enables email confirmation on signup

- enable_email_reconfirmation

  Enables email confirmation on user email change

- enable_welcome_mail

  Enables a Welcome email that is sent to User after registration

- enable_account_alias
  
  Enables alias on account

- enable_custom_domain

  Allow accounts to have custom domains

- enable_multiple_accounts
  
  Allow users to have multiple accounts

- enable_multiple_users_per_account

  Allow accounts to have multiple users
