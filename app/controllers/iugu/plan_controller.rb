class Iugu::PlanController < Iugu::AccountSettingsController
  def index
    params[:id] ? @account = current_user.accounts.find(params[:id]) : @account = current_user_account.account
    get_index_data
    render 'iugu/plan/index'
  end

  def change
    return unless params[:plan]
    params[:id] ? @account = current_user.accounts.find(params[:id]) : @account = current_user_account.account

    subscription = Iugu::Api::Subscription.find @account.subscription_id
    subscription.change_plan params[:plan]

    get_index_data
    render 'iugu/plan/index'
  end

  private

  def get_index_data
    @plans = Iugu::Api::Plan.all    
    @subscription = Iugu::Api::Subscription.find @account.subscription_id
    @currency = locale_to_currency I18n.locale
  end
end
