Rails.application.routes.draw do

  constraints(IuguSDK::ValidTenancyUrls) do
  end


  constraints(IuguSDK::RootTenancyUrl) do
    get "settings" => "settings#index", :as => "settings"
    get "settings/account" => "account#index", :as => "account_settings"
    get "settings/profile" => "profile#index", :as => "profile_settings"
    post "settings/profile" => "profile#update", :as => "profile_update"

    #get "login/using/twitter/callback" => "profile#add_social"
    #get "login/using/facebook/callback" => "profile#add_social"
    #get "settings/profile/destroy_social" => "profile#destroy_social", :as => 'social_destroy'
    #devise_scope :user do
    #  get 'email_confirmation' => "devise/confirmations#show", :as => 'user_confirmation'
    #end

    #devise_for :users, :skip => :all

    #get"login" => "sessions#new", :as => 'login'
    #post "login" => "sessions#create", :as => 'login'
    #delete "logout" => "sessions#destroy", :as => 'logout'

    #get "signup" => "registration#new", :as => 'signup'
    #post "signup" => "registration#create", :as => 'signup'

    devise_for :users,
      :path => 'account',
      :module => 'iugu',
      :skip => :all

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
      
    end

#user_session POST   /login(.:format)            {:action=>"create", :controller=>"iugu/sessions"}
#    destroy_user_session DELETE /logout(.:format)           {:action=>"destroy", :controller=>"iugu/sessions"}
#           user_password POST   /password(.:format)         {:action=>"create", :controller=>"iugu/passwords"}
#       new_user_password GET    /password/new(.:format)     {:action=>"new", :controller=>"iugu/passwords"}
#      edit_user_password GET    /password/edit(.:format)    {:action=>"edit", :controller=>"iugu/passwords"}
#                         PUT    /password(.:format)         {:action=>"update", :controller=>"iugu/passwords"}
#cancel_user_registration GET    /cancel(.:format)           {:action=>"cancel", :controller=>"iugu/registrations"}
#       user_registration POST   /                           {:action=>"create", :controller=>"iugu/registrations"}
#   new_user_registration GET    /signup(.:format)           {:action=>"new", :controller=>"iugu/registrations"}
#  edit_user_registration GET    /edit(.:format)             {:action=>"edit", :controller=>"iugu/registrations"}
#                         PUT    /                           {:action=>"update", :controller=>"iugu/registrations"}
#                         DELETE /                           {:action=>"destroy", :controller=>"iugu/registrations"}
#       user_confirmation POST   /confirmation(.:format)     {:action=>"create", :controller=>"iugu/confirmations"}
#   new_user_confirmation GET    /confirmation/new(.:format) {:action=>"new", :controller=>"iugu/confirmations"}
#                         GET    /confirmation(.:format)     {:action=>"show", :controller=>"iugu/confirmations"}

  end

end
