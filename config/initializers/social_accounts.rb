#OmniAuth.config.path_prefix = '/settings/account/link/'
begin 
  SOCIAL_ACC = YAML.load_file("#{Rails.root.to_s}/config/social_accounts.yml")
rescue
  SOCIAL_ACC = {}
end

Rails.application.config.middleware.use OmniAuth::Builder do
    configure do |config|
      config.path_prefix = "/login/using"
    end
    #provider :developer unless Rails.env.production?
    SOCIAL_ACC.keys.each do |provider|
      provider provider.to_sym, SOCIAL_ACC[provider]['token']
      provider provider.to_sym, SOCIAL_ACC[provider]['secret']
    end
end
