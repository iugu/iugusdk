Rails.application.routes.draw do

  constraints(IuguSDK::ValidTenancyUrls) do
  end

  constraints(IuguSDK::RootTenancyUrl) do

    get "settings" => "settings#index", :as => "settings"
    get "settings/account" => "account#index", :as => "account_settings"
    get "settings/profile" => "profile#index", :as => "profile_settings"
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

      
    end

  end

end
