class Iugu::AccountController < Iugu::AccountSettingsController

  before_filter(:only => [:destroy, :cancel_destruction, :update]) { |c| c.must_be :owner, :id }
  before_filter(:only => [:generate_new_token]) { |c| c.must_be :owner, :account_id }
  
  def index
    render 'iugu/settings/accounts'
  end

  def view
    if params[:id]
      @account = current_user.accounts.find(params[:id])
    else
      @account = current_user_account.account
    end
    @primary_domain = @account.account_domains.where(:primary => true).first if @account
    render 'iugu/settings/account'
  end

  def destroy
    account = current_user.accounts.find(params[:id])
    account.destroy
    redirect_to(account_settings_path, :notice => I18n.t("iugu.account_destruction_in") + account.destruction_job.run_at.to_s)
  end

  def cancel_destruction
    current_user.accounts.find(params[:id]).cancel_destruction
    notice = I18n.t("iugu.account_destruction_undone")
    redirect_to(account_settings_path, :notice => notice)
  end

  def select
    set_account(current_user, params[:id])
    redirect_to(account_settings_path, :notice => "Account selected")
  end

  def update
    @account = Account.find(params[:id])
    @account.update_attributes(params[:account])
    redirect_to account_view_path(params[:id]), :notice => I18n.t("iugu.notices.account_updated")
  end

  def create
    current_user.accounts << Account.create
    redirect_to account_settings_path
  end

  def generate_new_token
    @account = current_user.accounts.find(params[:account_id])
    @account.update_api_token
    redirect_to account_view_path(params[:account_id]), :notice => I18n.t("iugu.notices.new_token_generated")
  end

end
