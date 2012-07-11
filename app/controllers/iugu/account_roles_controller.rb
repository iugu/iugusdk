class Iugu::AccountRolesController < Iugu::SettingsController

  def edit
    @account = current_user.accounts.find(params[:id])
    @account_user = @account.account_users.find_by_user_id(params[:user_id])
    if current_user.is?(:owner, @account) || current_user.is?(:admin, @account)
      render 'iugu/account_roles/edit'
    else
      render :file => "#{Rails.root}/public/422.html", :status => 550
    end
  end

  def update
    @account = current_user.accounts.find(params[:id])
    @account_user = @account.account_users.find_by_user_id(params[:user_id])
    @account_user.set_roles(params[:roles])
    redirect_to account_users_index_path(@account.id), :notice => I18n.t("iugu.notices.roles_changed")
  end
  
end
