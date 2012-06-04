class ProfileController < SettingsController
  
  def index
    @user = current_user
    render 'iugu/profile_settings'
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
    else
      flash[:error] = @user.errors.full_messages
    end
    render 'iugu/profile_settings'
  end

end
