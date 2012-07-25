class Iugu::InvitationsController < Iugu::SettingsController
  before_filter :check_permissions

  def new
    @user_invitation = UserInvitation.new
    @account_id = params[:account_id]
  end

  def create
    params[:user_invitation][:roles] = params[:user_invitation][:roles].try(:join, ',')
    params[:user_invitation][:account_id] = params[:account_id]
    params[:user_invitation][:invited_by] = current_user.id
    @user_invitation = UserInvitation.create(params[:user_invitation])
    unless @user_invitation.new_record?
      redirect_to account_users_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.user_invited")
    else
      @account_id = params[:account_id]
      render :new
    end
  end

  def edit
    if @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
      @inviter = User.find(@user_invitation.invited_by)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    if @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
      @user_invitation.accept(current_user)
      redirect_to root_path
    else
      raise ActionController::RoutingError.new('Not Found')
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
