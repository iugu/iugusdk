class AccountUsersController < AccountSettingsController

  def index
    @account_users = Account.find(params[:account_id]).account_users
    render 'iugu/account_users/index'
  end

  def view
    @account_user = AccountUser.find_by_account_id_and_user_id(params[:account_id], params[:user_id])
    render 'iugu/account_users/view'
  end
  
end
