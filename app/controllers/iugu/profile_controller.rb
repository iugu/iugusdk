class Iugu::ProfileController < Iugu::SettingsController
  
  def index
    @user = current_user
    @social_accounts = @user.social_accounts
    render 'iugu/settings/profile'
  end

  def update
    @user = current_user
    @social_accounts = @user.social_accounts
    if @user.update_attributes(params[:user])
      sign_in @user, :bypass => true if !params[:user][:password].blank?
      flash.now[:notice] = I18n.t('iugu.notices.user_update')
    else
      flash.now[:error] = @user.errors.full_messages
    end
    render 'iugu/settings/profile'
  end

  def destroy
    (user = current_user).destroy
    redirect_to(profile_settings_path, :notice => I18n.t("iugu.user_destruction_in") + user.destruction_job.run_at.to_s)
  end

  def cancel_destruction
    current_user.cancel_destruction
    redirect_to(profile_settings_path, :notice => I18n.t("iugu.user_destruction_undone"))
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
    flash[:social] = notice
    redirect_to profile_settings_path
  end

end
