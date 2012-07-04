class AccountRolesController < SettingsController

  def edit
    @roles = Account.find(params[:id]).account_users.find_by_user_id(params[:user_id]).roles
    render 'iugu/account_roles/edit'
  end

  def update
    @account_user = Account.find(params[:id]).account_users.find_by_user_id(params[:user_id])
    @account_user.set_roles(params[:roles])
    render 'iugu/account_roles/update'
  end
  
end
