class Iugu::InvitationsController < ApplicationController

  def new
    @user_invitation = UserInvitation.new
    render 'iugu/invitations/new'
  end

  def create
    
  end

  def edit
    
  end

end
