class Iugu::AccountRolesController < Iugu::SettingsController

  before_filter(:only => [:edit, :update]) { |c| c.must_be [:owner, :admin], :id }

  def edit
    @account = current_user.accounts.find(params[:id])
    @account_user = @account.account_users.find_by_user_id(params[:user_id])
  end

  def update
    @account = current_user.accounts.find(params[:id])
    @account_user = @account.account_users.find_by_user_id(params[:user_id])
    @account_user.set_roles(params[:roles])
    redirect_to account_users_index_path(@account.id), :notice => I18n.t("iugu.notices.roles_changed")
  end
  
end
