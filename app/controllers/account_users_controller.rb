class AccountUsersController < SettingsController

  def index
    @account_users = Account.find(params[:account_id]).account_users
    render 'iugu/account_users/index'
  end

  def view
    @account_user = Account.find(params[:account_id]).account_users.find_by_user_id(params[:user_id])
    render 'iugu/account_users/view'
  end
  
end
