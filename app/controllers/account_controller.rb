class AccountController < AccountSettingsController
  
  def index
    render 'iugu/settings/accounts'
  end

  def view
    if params[:id]
      @account = current_user.accounts.find(params[:id])
    else
      @account = current_user_account
    end
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
