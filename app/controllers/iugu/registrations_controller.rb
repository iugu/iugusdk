class Iugu::RegistrationsController < Devise::RegistrationsController
  after_filter :select_account, :only => [:create,:update]
  before_filter :verify_private_api_secret, :only => [:create]

  layout IuguSDK.alternative_layout

  def new
    if IuguSDK::default_subscription_name.blank? && IuguSDK::enable_subscription_features && !params[:plan]
      redirect_to pricing_index_path
    else
      @invitation_token = session["invitation_token"]
      session["invitation_token"] = nil

      if IuguSDK::enable_subscription_features
        @plan_identifier = params[:plan] || IuguSDK::default_subscription_name
        @currency = locale_to_currency I18n.locale
      end
      super
    end
  end

  def create
    @invitation_token = params[:user][:user_invitation]
    params[:user][:user_invitation] = true unless @invitation_token.blank?
    params[:user][:locale] = @matched_locale_from_browser unless params[:user][:locale]
    super
  end

  def try_first
    if IuguSDK::enable_guest_user
      @user = User.create_guest
      @user.remember_me = true
      sign_in @user
      select_account
      flash[:notice] = I18n.t("iugu.notices.guest_login")
      redirect_to IuguSDK::app_main_url
    else
      raise ActionController::RoutingError.new("Not found")
    end
  end

  def after_sign_up_path_for(resource)
    @invitation_token.blank? ? IuguSDK::app_main_url : invitation_url
  end

  private

  def invitation_url
    edit_invite_url(:invitation_token => @invitation_token)
  end

  def verify_private_api_secret
    if request.format.json?
      render :json=>{:errors=>"Unauthorized"}, :status=>401 unless params[:private_api_secret] == IuguSDK::private_api_secret 
    end
  end
end
