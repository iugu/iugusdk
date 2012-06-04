Rails.application.routes.draw do

  constraints(IuguSDK::ValidTenancyUrls) do
  end

  get "settings" => "settings#index", :as => "settings"
  get "settings/account" => "account#index", :as => "account_settings"
  get "settings/profile" => "profile#index", :as => "profile_settings"

  devise_for :users, :skip => :all

  get"login" => "sessions#new", :as => 'login'
  post "login" => "sessions#create", :as => 'login'
  delete "logout" => "sessions#destroy", :as => 'logout'

  get "signup" => "registration#new", :as => 'signup'
  post "signup" => "registration#create", :as => 'signup'
end
