IuguSDK.setup do |config|
  config.app_main_url = '/'
  config.application_title = '<%= app_name %>'
  config.application_main_host = '<%= app_name %>.dev'
  config.application_main_host = '<%= app_name %>.com' if Rails.env.production?

  #Add your other options
  #Example:
  #config.enable_user_confirmation = true
end
