class Iugu::RegistrationsController < Devise::RegistrationsController
  after_filter :select_account, :only => [:create,:update]

  def try_first
    @user = User.create_guest
    @user.remember_me = true
    sign_in @user
    select_account
    flash[:notice] = I18n.t("iugu.notices.guest_login")
    redirect_to root_path
    #respond_with @user, :location => sign_up_path_for(@user)
  end
end

