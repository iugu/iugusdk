#OmniAuth.config.path_prefix = '/settings/account/link/'
begin 
  SOCIAL_ACCOUNTS = YAML.load_file("#{Rails.root.to_s}/config/social_accounts.yml")
rescue
  SOCIAL_ACCOUNTS = {}
end

Rails.application.config.middleware.use OmniAuth::Builder do
    configure do |config|
      config.path_prefix = "/login/using"
    end
    #provider :developer unless Rails.env.production?
    SOCIAL_ACCOUNTS.keys.each do |provider|
      provider provider.to_sym, SOCIAL_ACCOUNTS[provider]['token']
      provider provider.to_sym, SOCIAL_ACCOUNTS[provider]['secret']
    end
end
