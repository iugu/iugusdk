$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "iugusdk/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "iugusdk"
  s.version     = IuguSDK::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Iugusdk."
  s.description = "TODO: Description of Iugusdk."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1.4"
  s.add_dependency 'coffee-script'
  s.add_dependency 'haml'
  s.add_dependency 'haml-rails'
  s.add_dependency 'rails-i18n'
  s.add_dependency 'simple_form'
  s.add_dependency 'sass-rails'
  s.add_dependency 'rabl'
  s.add_dependency 'fuubar'
  s.add_dependency 'default_value_for'
  s.add_dependency 'paperclip'
  s.add_dependency 'prawn'
  s.add_dependency 'prawn_rails'
  s.add_dependency 'nokogiri'
  s.add_dependency 'less'
  s.add_dependency 'kaminari'
  s.add_dependency 'devise', "~> 2.1"
  s.add_dependency 'omniauth'
  s.add_dependency 'omniauth-twitter'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'http_accept_language'
  s.add_dependency 'delayed_job_active_record'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "fabrication"
  s.add_development_dependency "capybara"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "faker"
  s.add_development_dependency "populator"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rr"
end
