class SettingsController < ApplicationController

  before_filter :authenticate_user!

  layout Iugusdk.default_layout

  def index
    redirect_to :account_settings, :notice => flash[:notice]
  end

end
