class Iugu::SessionsController < Devise::SessionsController
  after_filter :select_account, :only => :create 

  def after_sign_in_path_for(resource_or_scope)
    IuguSDK::app_main_url
  end

  def after_sign_out_path_for(resource_or_scope)
    IuguSDK::app_root_url
  end

  layout IuguSDK.alternative_layout
end
