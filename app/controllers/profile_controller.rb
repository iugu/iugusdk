class ProfileController < SettingsController
  
  def index
    @user = current_user
    @social_accounts = @user.social_accounts
    render 'iugu/profile_settings'
  end

  def update
    @user = current_user
    @social_accounts = @user.social_accounts
    if @user.update_attributes(params[:user])
      flash[:notice] = I18n.t('iugu.notices.user_update')
    else
      flash[:error] = @user.errors.full_messages
    end
    render 'iugu/profile_settings'
  end

  def add_social
    if current_user 
      current_user.find_or_create_social(env["omniauth.auth"])
      redirect_to :action => 'index'
    else
      sign_in user = User.find_or_create_by_social(env["omniauth.auth"])
      redirect_to after_sign_in_path_for( user )
    end
  end

  def destroy_social
    current_user.social_accounts.where(:id => params[:id]).first.destroy
    redirect_to :action => 'index'
  end

end
