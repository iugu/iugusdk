class AccountRolesController < SettingsController

  def edit
    @roles = Account.find(params[:id]).account_user.find_by_user_id(params[:user_id]).roles
    render 'iugu/account_roles/edit'
  end

  def update
    render 'iugu/account_roles/update'
  end
  
end
