class Iugu::AccountUsersController < Iugu::AccountSettingsController

  before_filter(:only => [:destroy, :cancel_destruction]) { |c| c.must_be [:owner, :admin], :account_id }

  def index
    @account = Account.find(params[:account_id])
    @account_users = @account.account_users
    render 'iugu/account_users/index'
  end

  def view
    @account_user = AccountUser.find_by_account_id_and_user_id(params[:account_id], params[:user_id])
    render 'iugu/account_users/view'
  end

  def destroy
    if @account_user = AccountUser.find_by_account_id_and_user_id(params[:account_id], params[:user_id])
      @account = Account.find(params[:account_id])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
    raise ActionController::RoutingError.new('Access Denied') if @account_user.user_id == current_user.id || @account_user.is?(:owner)
    @account_user.destroy
    redirect_to account_users_index_path(params[:account_id]), :notice => I18n.t("iugu.account_user_destruction_in") + @account_user.destruction_job.run_at.to_s
  end

  def cancel_destruction
    if @account_user = AccountUser.find_by_account_id_and_user_id(params[:account_id], params[:user_id])
      @account = Account.find(params[:account_id])
      @account_user.cancel_destruction
      redirect_to account_users_index_path(params[:account_id]), :notice => I18n.t("iugu.account_user_destruction_undone")
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  
end
