class AccountController < SettingsController
  
  def index
    render 'iugu/settings/account'
  end

  def destroy
    begin
      (account = current_user.accounts.find(params[:id])).destroy if params[:id]
      notice = I18n.t("iugu.account_destruction_in") + account.destruction_job.run_at.to_s
    rescue
      notice = "Account not found"
    end
    redirect_to(account_settings_path, :notice => notice)
  end

  def cancel_destruction
    begin
      current_user.accounts.find(params[:id]).cancel_destruction if params[:id]
      notice = I18n.t("iugu.account_destruction_undone")
    rescue
      notice = "Account not found"
    end
      redirect_to(account_settings_path, :notice => notice)
  end

  def select
    select_account(current_user, params[:id])
    redirect_to(account_settings_path, :notice => "Account selected")
  end

end
