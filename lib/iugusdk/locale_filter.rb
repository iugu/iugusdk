module LocaleFilter

  def self.included(receiver)
    receiver.append_before_filter :set_locale
  end

  def set_locale
    @matched_locale_from_browser = request.preferred_language_from(AvailableLanguage.all)
    I18n.locale = current_user.locale || "en" if signed_in?
  end

end
