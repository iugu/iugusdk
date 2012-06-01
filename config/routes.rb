Rails.application.routes.draw do
  get "settings/index"

  devise_for :users, :skip => :all

  root :to => "sessions#new"
  post "login" => "sessions#create", :as => 'users_sign_in'
  delete "logout" => "sessions#destroy", :as => 'users_sign_out'

  get "signup" => "registration#new", :as => 'registration_new'
  post "signup" => "registration#create", :as => 'registration_create'

  get "dummy/test"

  get "settings/profile"

  # get "signup" => 'account#index'
  # post "signup" => 'account#signup'
end
