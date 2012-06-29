Rails.application.routes.draw do

  constraints(IuguSDK::ValidTenancyUrls) do
  end

  constraints(IuguSDK::RootTenancyUrl) do

    get "settings" => "settings#index", :as => "settings"
    get "settings/account" => "account#index", :as => "account_settings"
    get "settings/account/(:id)" => "account#view", :as => "account_view"
    delete "settings/account/(:id)" => "account#destroy", :as => "account_destroy"
    delete "settings/account/(:id)/cancel" => "account#cancel_destruction", :as => "account_cancel_destruction"

    get "settings/account/:account_id/users" => "account_users#index", :as => "account_users_index"
    get "settings/account/:account_id/user/:user_id" => "account_users#view", :as => "account_users_view"

    get "select_account/:id" => "account#select", :as => "account_select"
    get "settings/profile" => "profile#index", :as => "profile_settings"
    get "settings/profile/destroy" => "profile#destroy", :as => "profile_destroy"
    get "settings/profile/cancel_destruction" => "profile#cancel_destruction", :as => "profile_cancel_destruction"
    post "settings/profile" => "profile#update", :as => "profile_update"
    get "settings/profile/social/destroy" => "profile#destroy_social", :as => "social_destroy"

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
      get 'signup' => 'iugu/registrations#new', :as => 'new_user_registration'
      post 'signup' => 'iugu/registrations#create', :as => 'user_registration'
      get 'cancel_signup' => 'iugu/registrations#cancel', :as => 'cancel_user_registration'

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

      # Invitation Stuff
      get '/settings/account/:account_id/invite' => 'iugu/invitations#new', :as => 'new_invite'
      post '/settings/account/:account_id/invite' => 'iugu/invitations#create', :as => 'create_invite'
      get '/accept_invite/:invitation_token' => 'iugu/invitations#edit', :as => 'edit_invite'

    end

  end

end
