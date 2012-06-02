class RegistrationController < ApplicationController

  before_filter :disable_for_logged_users

  def disable_for_logged_users
    redirect_to Iugusdk::app_main_url if current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:user])
    redirect_to Iugusdk::app_main_url
  end
  
end
