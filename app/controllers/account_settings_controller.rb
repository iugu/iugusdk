class AccountSettingsController < SettingsController
  before_filter :block_removing
  
  private

  def block_removing
    if params[:account_id]
      if Account.find(params[:account_id]).destroying?
        render :file => "#{Rails.root}/public/404.html", :status => :not_found
      end
    end
  end
end
