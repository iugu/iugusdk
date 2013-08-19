class Iugu::AccountController < Iugu::AccountSettingsController

  before_filter(:only => [:destroy, :cancel_destruction, :update]) { |c| c.must_be :owner, :id }
  before_filter(:only => [:payment_history, :generate_new_token]) { |c| c.must_be :owner, :account_id }
  
  def index
    @accounts = current_user.accounts.order(:created_at)
    render 'iugu/settings/accounts'
  end

  def view
    if params[:id]
      @account = current_user.accounts.find(params[:id])
    else
      @account = current_user_account.account
    end

    @has_subscription = false

    if IuguSDK::enable_subscription_features
      unless @account.subscription_id.blank?
        @has_subscription = true
        @subscription = @account.subscription
        plan = Iugu::Api::Plan.find_by_identifier @subscription.plan_identifier
        @plan_name = plan.try :name
      end
    end
    @primary_domain = @account.account_domains.where(:primary => true).first if @account
    render 'iugu/settings/account'
  end

  def destroy
    if IuguSDK::enable_account_cancel
      account = current_user.accounts.find(params[:id])
      account.destroy
      redirect_to(account_settings_path, :notice => I18n.t("iugu.account_destruction_in") + account.destruction_job.run_at.to_s)
    else
      raise ActionController::RoutingError.new('Not found')
    end
  end

  def cancel_destruction
    current_user.accounts.find(params[:id]).cancel_destruction
    notice = I18n.t("iugu.account_destruction_undone")
    redirect_to(account_settings_path, :notice => notice)
  end

  def select
    set_account(current_user, params[:id])
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to(account_settings_path, :notice => "Account selected")
  end
  

  def update
    @account = Account.find(params[:id])
    @account.update_attributes(params[:account])
    flash[:group] = :account_update
    redirect_to account_view_path(params[:id]), :notice => I18n.t("iugu.notices.account_updated")
  end

  def create
    create_parameters = {}
    if IuguSDK::enable_subscription_features
      plan_identifier = params[:plan] || IuguSDK::default_subscription_name
      currency = locale_to_currency I18n.locale
      create_parameters = {plan_identifier: plan_identifier, currency: currency, email: current_user.email}
    end
    current_user.accounts << Account.create(create_parameters)
    redirect_to account_settings_path
  end

  def generate_new_token
    if IuguSDK::enable_account_api
      @account = current_user.accounts.find(params[:account_id])
      token = @account.tokens.create(description: params[:description], api_type: params[:api_type])
      if token.new_record?
        notice = token.errors.full_messages
      else
        notice = I18n.t("iugu.notices.new_token_generated")
      end
      flash[:group] = :api_token
      redirect_to account_view_path(params[:account_id]), :notice => notice
    else
      raise ActionController::RoutingError.new('Not found')
    end
  end

  def remove_token
    if IuguSDK::enable_account_api
      account = current_user.accounts.find params[:account_id]
      token = account.tokens.find params[:token] 
      if token.destroy
        notice = I18n.t("iugu.notices.token_removed")
      else
        notice = token.errors.full_messages
      end
      flash[:group] = :api_token
      redirect_to account_view_path(params[:account_id]), :notice => notice
    else
      raise ActionController::RoutingError.new('Not found')
    end
  end

  def payment_history
    get_account
    subscription = Iugu::Api::Subscription.find @account.subscription_id.to_uuid.to_s
    customer = Iugu::Api::Customer.find subscription.customer_id
    @invoices = Iugu::Api::Invoice.find :all, params: {hl: current_user.locale, customer_id: customer.id.to_param, status_filter: ["pending", "paid"], limit: 10}
    render 'iugu/account/payment_history'
  end

  def activate
    get_account
    if @account.subscription.try :activate 
      if @account.subscription.suspended
        notice = I18n.t("iugu.notices.account_will_be_activated")
      else
        notice = I18n.t("iugu.notices.account_activated")
      end
      @account.clear_cached_subscription_active
    else
      notice = I18n.t("iugu.notices.error_activating_account")
    end
    redirect_to account_view_path(params[:account_id]), :notice => notice
  end

  def suspend
    get_account
    if @account.subscription.try :suspend 
      notice = I18n.t("iugu.notices.account_suspended")
      @account.clear_cached_subscription_active
    else
      notice = I18n.t("iugu.notices.error_suspending_account")
    end
    redirect_to account_view_path(params[:account_id]), :notice => notice
  end

  private

  def get_account
    if params[:account_id]
      @account = current_user.accounts.find(params[:account_id])
    else
      @account = current_user_account.account
    end
  end

end
