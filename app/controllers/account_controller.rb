class AccountController < SettingsController
  
  def index
    render 'iugu/settings/account'
  end

  def destroy
    begin
      current_user.accounts.find(params[:id]).destroy if params[:id]
    rescue
    end
    redirect_to :action => :index
  end

  def cancel_destruction
    begin
      current_user.accounts.find(params[:id]).cancel_destruction if params[:id]
    rescue
    end
    redirect_to :action => :index
  end

end
