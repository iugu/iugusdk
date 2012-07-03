class Iugu::InvitationsController < SettingsController

  def new
    @user_invitation = UserInvitation.new
    @account_id = params[:account_id]
  end

  def create
    @user_invitation = UserInvitation.new(params[:user_invitation])
    @user_invitation.account_id = params[:account_id]
    @user_invitation.save
    redirect_to 'new'
  end

  def edit
    render :file => "#{Rails.root}/public/404.html", :status => :not_found unless @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
  end

  def update
    
  end

end
