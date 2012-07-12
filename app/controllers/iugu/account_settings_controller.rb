class Iugu::AccountSettingsController < Iugu::SettingsController
  before_filter :block_removing
  
  private

  def block_removing
    begin
      if params[:account_id]
        if Account.find(params[:account_id]).destroying?
          render :file => "#{Rails.root}/public/422.html", :status => 550
        end
      end
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
