class Iugu::PlanController < Iugu::AccountSettingsController
  before_filter(:only => [:index, :change]) { |c| c.must_be :owner, :id }

  def index
    params[:id] ? @account = current_user.accounts.find(params[:id]) : @account = current_user_account.account
    get_index_data
    render 'iugu/plan/index'
  end

  def change
    return unless params[:plan]
    params[:id] ? @account = current_user.accounts.find(params[:id]) : @account = current_user_account.account

    subscription = Iugu::Api::Subscription.find @account.subscription_id.to_uuid.to_s
    @account.clear_cached_subscription_features if subscription.change_plan params[:plan]

    get_index_data
    render 'iugu/plan/index'
  end

  private

  def get_index_data
    @currency = locale_to_currency I18n.locale
    @plans = Iugu::Api::Plan.with_currency @currency

    @subscription = Iugu::Api::Subscription.find @account.subscription_id.to_uuid.to_s
  end
end
