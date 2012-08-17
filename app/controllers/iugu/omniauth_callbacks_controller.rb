class Iugu::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def method_missing(provider)
    if !User.omniauth_providers.index(provider).nil?
      if current_user 
        raise ActionController::RoutingError.new("Not found") unless IuguSDK::enable_social_linking
        current_user.find_or_create_social(env["omniauth.auth"])
        redirect_to(env["omniauth.origin"] || root_path)
      else
        raise ActionController::RoutingError.new("Not found") unless IuguSDK::enable_social_login
        if user = User.find_or_create_by_social(env["omniauth.auth"])
          sign_in user
          select_account
          redirect_to after_sign_in_path_for( user )
        else
          redirect_to (env["omniauth.origin"] || root_path), :notice => I18n.t('errors.messages.email_already_in_use')
        end 
      end
    end
  end
  
  def passthru
    render :status => 404, :text => "Not found. Authentication passthru."
  end
end
