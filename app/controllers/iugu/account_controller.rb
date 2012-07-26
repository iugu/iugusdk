class Iugu::AccountController < Iugu::AccountSettingsController
  
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
    begin
      if account = current_user.accounts.find(params[:id])
        if account.account_users.find_by_user_id(current_user.id).is?(:owner)
          account.destroy
          notice = I18n.t("iugu.account_destruction_in") + account.destruction_job.run_at.to_s
        else
          notice = I18n.t("errors.messages.only_owners_can_destroy_accounts")
        end
      end
    rescue
      notice = I18n.t("iugu.notices.account_not_found")
    end
    redirect_to(account_settings_path, :notice => notice)
  end

  def cancel_destruction
    begin
      current_user.accounts.find(params[:id]).cancel_destruction if params[:id]
      notice = I18n.t("iugu.account_destruction_undone")
    rescue
      notice = I18n.t("iugu.notices.account_not_found")
    end
    redirect_to(account_settings_path, :notice => notice)
  end

  def select
    select_account(current_user, params[:id])
    redirect_to(account_settings_path, :notice => "Account selected")
  end

  def update
    begin
      @account = Account.find(params[:id])
      @account.update_attributes(params[:account])
      redirect_to account_view_path(params[:id]), :notice => I18n.t("iugu.notices.account_updated")
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
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
