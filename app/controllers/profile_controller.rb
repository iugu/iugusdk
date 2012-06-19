class ProfileController < SettingsController
  
  def index
    @user = current_user
    @social_accounts = @user.social_accounts
    render 'iugu/settings/profile'
  end

  def update
    @user = current_user
    @social_accounts = @user.social_accounts
    if @user.update_attributes(params[:user])
      flash[:notice] = I18n.t('iugu.notices.user_update')
    else
      flash[:error] = @user.errors.full_messages
    end
    render 'iugu/settings/profile'
  end

  def destroy_social
    current_user.social_accounts.where(:id => params[:id]).first.destroy
    redirect_to :action => 'index'
  end

end
