module IuguSDKBaseController

  def self.included(receiver)
    receiver.append_before_filter :configure_locale
  end

  def select_account
    set_account(current_user) if current_user
  end

  def configure_locale
    @matched_locale_from_browser = request.preferred_language_from(AvailableLanguage.all)
    if signed_in?
      if current_user.locale.blank?
        locale = "en" 
      else
        locale = current_user.locale
      end
    end
  end

end
