require 'rubygems'

require 'simplecov'
SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda-matchers'
require 'fabrication'
require 'capybara/rspec'
require 'database_cleaner'
require 'rr'

require File.dirname(__FILE__) + "/controller_macros"
require File.dirname(__FILE__) + "/request_macros"

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

Fabrication.configure do |config|
  config.fabricator_dir = "../fabricators"
end

Capybara.app_host = 'http://iugusdk.dev'

OmniAuth.config.test_mode = true

# Enable OmniAuth Mockup for Twitter
OmniAuth.config.add_mock(
  :twitter,
  {
    :provider => "twitter",
    :uid      => "1234",
    :user_info => {
      :name => "Bob Hope",
      :nickname => "bobby",
      :urls     => {
        :Twitter => "www.twitter.com/bobster"
      }
    },
    :credentials => {
      :token => "lk2j3lkjasldkjflk3ljsdf"
    },
    :extra => {
      :raw_info => {
      }
    }
  }
)
# Enable OmniAuth Mockup for Facebook
OmniAuth.config.add_mock(
  :facebook,
  {
    :provider => "facebook",
    :uid      => "1234",
    :user_info => {
      :name => "Bob Hope"
    },
    :credentials => {
      :token => "lk2j3lkjasldkjflk3ljsdf"
    },
    :extra => {
      :raw_info => {
        :email => "facebook@test.test"
      }
    }
  }
)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rr
  
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :view
  config.include Devise::TestHelpers, :type => :helper
  config.include IuguSDK::Controllers::Helpers, :type => :controller
  config.include ControllerMacros, :type => :controller

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end
