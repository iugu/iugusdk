class AccountSettingsController < SettingsController
  before_filter :block_removing
  
  private

  def block_removing
    if params[:account_id]
      if Account.find(params[:account_id]).destroying?
        render :file => "#{Rails.root}/public/422.html", :status => 550
      end
    end
  end
end
