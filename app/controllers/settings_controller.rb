class SettingsController < ApplicationController

  before_filter :authenticate_user!, :except => :add_social

  layout IuguSDK.default_layout

  def index
    redirect_to :profile_settings, :notice => flash[:notice]
  end

end
