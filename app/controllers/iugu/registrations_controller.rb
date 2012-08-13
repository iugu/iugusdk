class Iugu::RegistrationsController < Devise::RegistrationsController
  after_filter :select_account, :only => [:create,:update]

  layout IuguSDK.alternative_layout

  def try_first
    if IuguSDK::enable_guest_user
      @user = User.create_guest
      @user.remember_me = true
      sign_in @user
      select_account
      flash[:notice] = I18n.t("iugu.notices.guest_login")
      redirect_to root_path
      #respond_with @user, :location => sign_up_path_for(@user)
    else
      raise ActionController::RoutingError.new("Not found")
    end
  end

  def after_sign_up_path_for(resource)
    IuguSDK::app_main_url
  end
end

