class RegistrationController < ApplicationController

  def new
    redirect_to Iugusdk::app_main_url if current_user
    @user = User.new
  end

  def create
    @user = User.create(params[:user])
    redirect_to Iugusdk::app_main_url
  end
  
end
