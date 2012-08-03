Rails.application.routes.draw do

  constraints(IuguSDK::ValidTenancyUrls) do
  end

  constraints(IuguSDK::RootTenancyUrl) do

    get "settings" => "iugu/settings#index", :as => "settings"
    get "settings/accounts" => "iugu/account#index", :as => "account_settings"
    get "settings/account/(:id)" => "iugu/account#view", :as => "account_view"
    delete "settings/account/(:id)" => "iugu/account#destroy", :as => "account_destroy"
    delete "settings/account/(:id)/cancel" => "iugu/account#cancel_destruction", :as => "account_cancel_destruction"
    post "settings/account/(:account_id)/generate_new_token" => "iugu/account#generate_new_token", :as => "account_generate_new_token"
    put "settings/account/(:id)" => "iugu/account#update", :as => "account_update"
    post "settings/account" => "iugu/account#create", :as => "account_create"

    get "settings/account/:account_id/users" => "iugu/account_users#index", :as => "account_users_index"
    get "settings/account/:account_id/user/:user_id" => "iugu/account_users#view", :as => "account_users_view"
    delete "settings/account/:account_id/user/:user_id" => "iugu/account_users#destroy", :as => "account_users_destroy"
    delete "settings/account/:account_id/user/:user_id/cancel" => "iugu/account_users#cancel_destruction", :as => "account_users_cancel_destruction"

    get "settings/account/:account_id/domains" => "iugu/account_domains#index", :as => "account_domains_index"
    post '/settings/account/:account_id/domain' => 'iugu/account_domains#create', :as => 'create_domain'
    delete "settings/account/:account_id/domain/:domain_id" => "iugu/account_domains#destroy", :as => "account_domains_destroy"
    get "settings/account/:account_id/domain/:domain_id" => "iugu/account_domains#instructions", :as => "account_domains_instructions"
    post '/settings/account/:account_id/domain/:domain_id' => 'iugu/account_domains#verify', :as => 'verify_domain'
    post '/settings/account/:account_id/domain/:domain_id/primary' => 'iugu/account_domains#primary', :as => 'primary_domain'
    put '/settings/account/:account_id/subdomain' => 'iugu/account_domains#update_subdomain', :as => 'update_subdomain'

    get "select_account/:id" => "iugu/account#select", :as => "account_select"
    get "settings/profile" => "iugu/profile#index", :as => "profile_settings"
    get "settings/profile/destroy" => "iugu/profile#destroy", :as => "profile_destroy"
    get "settings/profile/cancel_destruction" => "iugu/profile#cancel_destruction", :as => "profile_cancel_destruction"
    post "settings/profile" => "iugu/profile#update", :as => "profile_update"
    get "settings/profile/social/destroy" => "iugu/profile#destroy_social", :as => "social_destroy"

    get '/settings/account/:account_id/invite' => 'iugu/invitations#new', :as => 'new_invite'
    post '/settings/account/:account_id/invite' => 'iugu/invitations#create', :as => 'create_invite'
    get '/accept_invite/:invitation_token' => 'iugu/invitations#edit', :as => 'edit_invite'
    post '/accept_invite' => 'iugu/invitations#update', :as => 'update_invite'
    get "/settings/account/(:id)/user/:user_id/roles" => "iugu/account_roles#edit", :as => "account_roles_edit"
    post "/settings/account/(:id)/user/:user_id/roles" => "iugu/account_roles#update", :as => "account_roles_update"

    devise_for :users,
      :path => 'account',
      :module => 'iugu',
      :only => :omniauth_callbacks
      # :skip => :all

    as :user do
      # Session Stuff
      get 'login' => 'iugu/sessions#new', :as => 'new_user_session'
      post 'login' => 'iugu/sessions#create', :as => 'user_session'
      delete 'logout' => 'iugu/sessions#destroy', :as => 'destroy_user_session' 

      # Registration Stuff
      unless IuguSDK::enable_social_only
        get 'signup' => 'iugu/registrations#new', :as => 'new_user_registration'
        post 'signup' => 'iugu/registrations#create', :as => 'user_registration'
        get 'cancel_signup' => 'iugu/registrations#cancel', :as => 'cancel_user_registration'
      end

      # Confirmation Stuff
      post 'confirmation' => 'iugu/confirmations#create', :as => 'user_confirmation'
      get 'confirmation/new' => 'iugu/confirmations#new', :as => 'new_user_confirmation'
      get 'confirmation' => 'iugu/confirmations#show', :as => 'show_user_confirmation'

      # Forgot Stuff
      post 'forgot_password' => 'iugu/passwords#create', :as => 'user_password'
      get 'forgot_password' => 'iugu/passwords#new', :as => 'new_user_password'
      get 'forgot_password/edit' => 'iugu/passwords#edit', :as => 'edit_user_password'
      put 'forgot_password' => 'iugu/passwords#update', :as => 'update_user_pasword'

      # Omniauth Stuff
      get '/account/auth/:provider' => 'iugu/omniauth_callbacks#passthru'

    end

  end

end
