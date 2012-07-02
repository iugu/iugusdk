class Iugu::InvitationsController < ApplicationController

  def new
    @user_invitation = UserInvitation.new
  end

  def create
    UserInvitation.create(params[:user_invitation])
    redirect_to 'new'
  end

  def edit
    render :file => "#{Rails.root}/public/404.html", :status => :not_found unless @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
  end

end
