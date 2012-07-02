class Iugu::InvitationsController < ApplicationController

  def new
    @user_invitation = UserInvitation.new
  end

  def create
    UserInvitation.create(params[:user_invitation])
    redirect_to 'new'
  end

  def edit
    
  end

end
