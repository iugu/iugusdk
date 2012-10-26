require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require
require "iugusdk"
require "fabrication"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Fabrication
    config.generators do |g|
      g.test_framework  :rspec, :fixture => true
      g.fixture_replacement :fabrication, :dir => "spec/fabricators"
    end
    
    # Config Mailer

    config.action_mailer.smtp_settings = { 
      address: "smtp.gmail.com",
      port: 587,
      domain: "iugu.com.br",
      user_name: "envio@iugu.com.br",
      password: "envioiugu",
      authentication: :plain,
      enable_starttls_auto: true
    }

    # config.session_store :disabled
    # config.middleware.delete(ActionDispatch::Cookies)
    # config.middleware.delete(ActionDispatch::Session::CookieStore) 

  end
end

