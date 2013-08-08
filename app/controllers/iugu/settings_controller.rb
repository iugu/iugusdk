class Iugu::SettingsController < ApplicationController

  before_filter :authenticate_user!, :except => :add_social
  before_filter :verify_token

  layout IuguSDK.default_layout

  def index
    redirect_to :profile_settings, :notice => flash[:notice]
  end

  def must_be (roles, param_name)
    access = false
    @account_user = AccountUser.find_by_user_id_and_account_id(current_user.id, params[param_name])
    raise ActionController::RoutingError.new("Not Found") unless @account_user
    if roles.class == Array
      roles.each do |role|
        access = true if @account_user.is?(role)
      end
    else
      access = true if @account_user.is?(roles)
    end
    raise ActionController::RoutingError.new("Access Denied") if access == false
  end

  private

  def verify_token
    if IuguSDK::enable_user_api
      current_user.send(:init_token) unless current_user.token
    end
  end

end
