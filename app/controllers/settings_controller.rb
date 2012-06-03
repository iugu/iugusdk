class SettingsController < ApplicationController

  before_filter :authenticate_user!

  layout IuguSDK.default_layout

  def index
    redirect_to :profile_settings, :notice => flash[:notice]
  end

end
