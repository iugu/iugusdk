module IuguSDKBaseController

  def self.included(receiver)
    receiver.append_before_filter :configure_locale
  end

  def select_account
    Rails.logger.info "SELECT ACCOUNT"
    set_account(current_user) if current_user
  end

  def configure_locale
    @matched_locale_from_browser = request.preferred_language_from(AvailableLanguage.all)
    I18n.locale = current_user.locale || "en" if signed_in?
  end

end
