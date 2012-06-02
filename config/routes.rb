Rails.application.routes.draw do

  get "settings" => "settings#index", :as => "settings"
  get "settings/account" => "account#index", :as => "account_settings"

  devise_for :users, :skip => :all

  root :to => "sessions#new"
  post "login" => "sessions#create", :as => 'users_sign_in'
  delete "logout" => "sessions#destroy", :as => 'users_sign_out'

  get "signup" => "registration#new", :as => 'registration_new'
  post "signup" => "registration#create", :as => 'registration_create'

  get "dummy/test"
end
