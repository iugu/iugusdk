#OmniAuth.config.path_prefix = '/settings/account/link/'

Rails.application.config.middleware.use OmniAuth::Builder do
    #provider :developer unless Rails.env.production?
    provider :twitter, ENV['532382714-LQq2JqAVbc8FMa6b2t9HV7fYE00YzOVYA6cOGiz2'], ENV['1IFrG2vSjpGZ2xNPOaSE6Qsf8CeUKKEn8gAixJ9P1cU']
end
