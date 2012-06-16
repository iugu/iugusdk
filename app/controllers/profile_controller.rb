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

  def add_social
    if current_user 
      current_user.find_or_create_social(env["omniauth.auth"])
      redirect_to :action => 'index'
    else
      if user = User.find_or_create_by_social(env["omniauth.auth"])
        sign_in user
        redirect_to after_sign_in_path_for( user )
      else
        redirect_to signup_path, :notice => I18n.t('errors.messages.email_already_in_use')
      end
    end
  end

  def destroy_social
    current_user.social_accounts.where(:id => params[:id]).first.destroy
    redirect_to :action => 'index'
  end

end
