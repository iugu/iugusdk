class RegistrationController < AuthenticableController

  before_filter :disable_for_logged_users

  def disable_for_logged_users
    redirect_to IuguSDK::app_main_url if current_user
  end

  def new
    @user = User.new
    render 'iugu/signup'
  end

  def create
    @user = User.new(params[:user].merge({:locale => detect_locale}))
    if @user.save

      new_account = Account.create({})
      account_user = new_account.account_users.create( { :user => @user } )

      sign_in_and_select_account_for @user
      redirect_to IuguSDK::app_main_url, :notice => "Thank you for sign up"
    else  
      render 'iugu/signup'
    end  
  end

  private

  def detect_locale
    request.preferred_language_from(AvailableLanguage.all)
  end
  
end
