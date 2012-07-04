class AccountRolesController < SettingsController

  def edit
    @account = Account.find(params[:id])
    @account_user = @account.account_users.find_by_user_id(params[:user_id])
    render 'iugu/account_roles/edit'
  end

  def update
    @account = Account.find(params[:id])
    @account_user = @account.account_users.find_by_user_id(params[:user_id])
    @account_user.set_roles(params[:roles])
    render 'iugu/account_roles/edit'
  end
  
end
