class Iugu::RegistrationsController < Devise::RegistrationsController
  after_filter :select_account, :only => [:create,:update]
  before_filter :verify_private_api_secret, :only => [:create]

  layout IuguSDK.alternative_layout

  def new
    if !IuguSDK::default_subscription_name && IuguSDK::enable_subscription_features && !params[:plan]
      redirect_to pricing_index_path
    else
      if IuguSDK::enable_subscription_features
        ps = []
        Iugu::Api::Plan.all.each { |p| ps << p if p.identifier == (params[:plan] || IuguSDK::default_subscription_name) }
        if plan = ps.first
          @plan_id = plan.id
          plan.prices.each { |p| @price_id = p.id if p.currency == locale_to_currency(I18n.locale) }
        end
      end
      super
    end
  end

  def create
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
      #respond_with @user, :location => sign_up_path_for(@user)
    else
      raise ActionController::RoutingError.new("Not found")
    end
  end

  def after_sign_up_path_for(resource)
    IuguSDK::app_main_url
  end

  private

  def verify_private_api_secret
    if request.format.json?
      render :json=>{:errors=>"Unauthorized"}, :status=>401 unless params[:private_api_secret] == IuguSDK::private_api_secret 
    end
  end
end
