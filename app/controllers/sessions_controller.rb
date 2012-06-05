class SessionsController < AuthenticableController
  # prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :allow_params_authentication!, :only => :create

  def new
    @user = User.new(params[:user])
    render 'iugu/login'
  end
  
  def create
    user = authenticate_user!(:recall => "sessions#new")
    flash[:notice] = I18n.t("devise.sessions.signed_in")
    sign_in_and_select_account_for user
    redirect_to after_sign_in_path_for( user )
  end

  def destroy
    sign_out
    flash[:notice] = I18n.t("devise.sessions.signed_out")
    redirect_to IuguSDK::app_root_url
  end

end
