class Iugu::InvitationsController < Iugu::SettingsController

  skip_before_filter :authenticate_user!, :only => :edit
  before_filter(:only => [:new, :create]) { |c| c.must_be [:owner, :admin], :account_id } 
  after_filter :select_account, :only => [:update]

  def new
    @user_invitation = UserInvitation.new
    @account = Account.find(params[:account_id])
  end

  def create
    flash[:group] = :user_invitation
    params[:user_invitation][:roles] = params[:user_invitation][:roles].try(:join, ',')
    params[:user_invitation][:account_id] = params[:account_id]
    params[:user_invitation][:invited_by] = current_user.id
    @user_invitation = UserInvitation.create(params[:user_invitation])
    unless @user_invitation.new_record?
      flash[:group] = :general
      redirect_to account_users_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.user_invited")
    else
      @account = Account.find(params[:account_id])
      render :new
    end
  end

  def edit
    raise ActionController::RoutingError.new('Not Found') unless @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
    @inviter = User.find(@user_invitation.invited_by)
  end

  def update
    if @user_invitation = UserInvitation.find_by_invitation_token(params[:invitation_token])
      if @user_invitation.accept(current_user)
        redirect_to IuguSDK::app_main_url
      else
        redirect_to root_path, :notice => I18n.t("iugu.notices.you_are_already_member_of_this_account")
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
