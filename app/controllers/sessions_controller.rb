class SessionsController < ApplicationController
  # prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :allow_params_authentication!, :only => :create

  def new
    @user = User.new(params[:user])
    # TODO: Rewrite
    @current_user_on_account = current_user_account
    @current_roles_on_account = current_user_account.account_roles.map(&:name).to_s if @current_user_on_account
  end
  
  def create
    user = authenticate_user!(:recall => "sessions#new")
    flash[:notice] = "You are now signed in!"
    sign_in_and_redirect user
    # redirect_to root_path
  end

  def destroy
    sign_out
    flash[:notice] = "You are now signed out!"
    redirect_to root_path
  end

end
