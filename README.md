IuguSDK
=========

How to use it
---------

**Create your Ruby on Rails 3.2.14 Project**

    rails _3.2.14_ new myapp_name -d mysql
    cd myapp_name

**Add to your Gemfile**
  
```ruby
gem 'iugusdk'
```

**Config file**

config/initializers/iugusdk.rb

```ruby
IuguSDK.setup do |config|
  config.app_main_url = '/'
  config.application_title = 'myapp_name'
  config.application_main_host = 'myapp_domain.dev'
  config.application_main_host = 'myapp_domain.com' if Rails.env.production?

  #Add your other options
  #Example:
  #config.enable_user_confirmation = true
end
```

**Run delayed jobs**

  $bundle exec rake jobs:work

This is needed for delay exclusion features


Available options
-----------

- **enable_social_login**

  Enable login using facebook and twitter

- **enable_social_linking**

  Allows users to link their facebook and twitter account to your application user

- **enable_guest_user**

  Enables login as guest user

- **enable_user_confirmation**

  Enables email confirmation on signup

- **enable_email_reconfirmation**

  Enables email confirmation on user email change

- **enable_welcome_mail**

  Enables a Welcome email that is sent to User after registration

- **enable_account_alias**
  
  Enables alias on account

- **enable_custom_domain**

  Allow accounts to have custom domains

- **enable_multiple_accounts**
  
  Allow users to have multiple accounts

- **enable_multiple_users_per_account**

  Allow accounts to have multiple users

- **enable_user_api**

  Enables User api token

- **enable_account_api**

  Enables Account api tokens

- **account_api_tokens**

  Set available types of Account ApiTokens

  Example:

```ruby
config.account_api_tokens = [ 'test', 'admin', 'read-only' ]
```

- **enable_account_cancel**

  Enables account exclusion (enabled by default)

- **enable_user_cancel**

  Enables user exclusion (enabled by default)

- **delay_account_exclusion**

  Set a delay to account exclusion
  
  Examples:

```ruby  
config.delay_account_exclusion = 30.minutes
config.delay_account_exclusion = 5.days
```

- **delay_user_exclusion**

  Set a delay to user exclusion
  
  Examples:
  
```ruby
config.delay_user = 30.minutes
config.delay_user = 5.days
```
