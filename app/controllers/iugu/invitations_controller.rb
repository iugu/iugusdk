class Iugu::InvitationsController < SettingsController
  before_filter :check_permissions

  def new
    @user_invitation = UserInvitation.new
    @account_id = params[:account_id]
  end

  def create
    params[:user_invitation][:roles] = params[:user_invitation][:roles].try(:join, ',')
    @user_invitation = UserInvitation.new(params[:user_invitation])
    @user_invitation.invited_by = current_user.id
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


  private

  def check_permissions
    if params[:account_id]
      begin
        account = current_user.accounts.find(params[:account_id])
      rescue
        raise ActionController::RoutingError.new('Access denied')
      end
      raise ActionController::RoutingError.new('Access denied') unless current_user.is?(:owner, account) || current_user.is?(:admin, account)
    end
  end

end
