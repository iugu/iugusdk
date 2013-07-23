class Iugu::SessionsController < Devise::SessionsController
  after_filter :select_account, :only => :create 

  layout IuguSDK.alternative_layout

  def after_sign_in_path_for(resource_or_scope)
    puts params
    params[:user].try(:[], :user_invitation).blank? ? IuguSDK::app_main_url : invitation_url
  end

  def after_sign_out_path_for(resource_or_scope)
    IuguSDK::app_root_url
  end

  private

  def invitation_url
    edit_invite_url(:invitation_token => params[:user][:user_invitation])
  end

end
