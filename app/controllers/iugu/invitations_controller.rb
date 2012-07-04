class Iugu::InvitationsController < SettingsController

  def new
    @user_invitation = UserInvitation.new
    @account_id = params[:account_id]
  end

  def create
    @user_invitation = UserInvitation.new(params[:user_invitation])
    @user_invitation.account_id = params[:account_id]
    @user_invitation.save
    redirect_to :action => :new
  end

  def edit
    if @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
      @inviter = User.find(@user_invitation.invited_by)
    else
      render :file => "#{Rails.root}/public/404.html", :status => :not_found 
    end
  end

  def update
    if @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
      @user_invitation.accept(current_user)
      redirect_to root_path
    else
      render :file => "#{Rails.root}/public/404.html", :status => :not_found
    end
  end

end
