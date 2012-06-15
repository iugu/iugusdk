Rails.application.routes.draw do

  constraints(IuguSDK::ValidTenancyUrls) do
  end


  constraints(IuguSDK::RootTenancyUrl) do
    get "settings" => "settings#index", :as => "settings"
    get "settings/account" => "account#index", :as => "account_settings"
    get "settings/profile" => "profile#index", :as => "profile_settings"
    post "settings/profile" => "profile#update", :as => "profile_update"
    get "login/using/twitter/callback" => "profile#add_social"
    get "login/using/facebook/callback" => "profile#add_social"
    get "settings/profile/destroy_social" => "profile#destroy_social", :as => 'social_destroy'
    devise_scope :user do
      get 'email_confirmation' => "devise/confirmations#show", :as => 'user_confirmation'
    end

    devise_for :users, :skip => :all

    get"login" => "sessions#new", :as => 'login'
    post "login" => "sessions#create", :as => 'login'
    delete "logout" => "sessions#destroy", :as => 'logout'

    get "signup" => "registration#new", :as => 'signup'
    post "signup" => "registration#create", :as => 'signup'
  end

end
