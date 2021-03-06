class Iugu::ProfileController < Iugu::SettingsController
  
  def index
    @user = current_user
    @social_accounts = @user.social_accounts
    render 'iugu/settings/profile'
  end

  def update
    @user = current_user
    @social_accounts = @user.social_accounts
    if params[:form_group] == "password"
      flash.now[:group] = :password
    else
      flash.now[:group] = :profile_update
    end
    if @user.update_attributes(params[:user])
      I18n.locale = @user.locale 
      sign_in @user, :bypass => true if !params[:user][:password].blank?
      flash.now[:notice] = I18n.t('iugu.notices.user_update')
    end
    render 'iugu/settings/profile'
  end

  def destroy
    if IuguSDK::enable_user_cancel
      (user = current_user).destroy
      flash[:group] = :remove_user
      flash[:error] = I18n.t("iugu.user_destruction_in") + user.destruction_job.run_at.to_s
      redirect_to(profile_settings_path)
    else
      raise ActionController::RoutingError.new("Not found")
    end
  end

  def cancel_destruction
    flash[:group] = :remove_user
    flash[:error] = I18n.t("iugu.user_destruction_undone")
    current_user.cancel_destruction
    redirect_to(profile_settings_path)
  end

  def destroy_social
    begin
      if social_account = current_user.social_accounts.where(:id => params[:id]).first.unlink
        notice = I18n.t("iugu.social_unlinked")
      else
        notice = I18n.t("errors.messages.only_social_and_no_email")
      end
    rescue
      notice = I18n.t("errors.messages.not_found")
    end
    flash[:notice] = notice
    flash[:group] = :social
    redirect_to profile_settings_path
  end

  def become_user
    if current_user.guest
      @user = current_user
      if current_user.become_user(params[:user])
        sign_in @user
        select_account
        redirect_to root_path, :notice => I18n.t("iugu.notices.congrats_for_becoming_user")
      else
        render 'iugu/settings/profile'
      end 
    else
      raise ActionController::RoutingError.new("Not found")
    end 
  end 

  def renew_token
    if IuguSDK::enable_user_api
      current_user.token.refresh
      flash[:group] = :api
      flash[:notice] = I18n.t("iugu.notices.new_token_generated")
      redirect_to profile_settings_path
    else
      raise ActionController::RoutingError.new("Not found")
    end
  end

end
