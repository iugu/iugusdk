class SessionsController < ApplicationController
  # prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :allow_params_authentication!, :only => :create

  def new
    @user = User.new(params[:user])
  end
  
  def create
    user = authenticate_user!(:recall => "sessions#new")
    flash[:notice] = "You are now signed in!"
    sign_in user
    select_account
    redirect_to after_sign_in_path_for( user )
  end

  def destroy
    sign_out
    flash[:notice] = "You are now signed out!"
    redirect_to root_path
  end

end
