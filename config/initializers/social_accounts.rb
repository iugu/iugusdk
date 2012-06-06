#OmniAuth.config.path_prefix = '/settings/account/link/'

Rails.application.config.middleware.use OmniAuth::Builder do
    configure do |config|
      config.path_prefix = "/settings/account/link"
    end
    #provider :developer unless Rails.env.production?
    provider :twitter, 'BoAbWcBtO2j3zIVMaQNmg', 'M4n1alFTKQlDQ8geFDXByIDUYfVggde5EDB1PinBs'
end
