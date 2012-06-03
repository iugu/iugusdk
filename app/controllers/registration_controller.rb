class RegistrationController < ApplicationController

  before_filter :disable_for_logged_users

  def disable_for_logged_users
    redirect_to IuguSDK::app_main_url if current_user
  end

  def new
    @user = User.new
    render 'iugu/signup'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # TODO: Write tests HERE
      # TODO: Can we do better?
      new_account = Account.create({})
      account_user = new_account.account_users.create( { :user => @user } )
      redirect_to IuguSDK::app_main_url, :notice => "Thank you for sign up"
    else  
      # render :action => 'new'
      render 'iugu/signup'
    end  
  end
  
end
