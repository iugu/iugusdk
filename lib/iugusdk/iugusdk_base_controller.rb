module IuguSDKBaseController

  def self.included(receiver)
    receiver.append_before_filter :configure_locale
  end

  def select_account
    set_account(current_user) if current_user
  end

  def configure_locale
    if(params[:hl])
      locale = params[:hl] if AvailableLanguage.all.values.include? params[:hl]
    end
    unless locale
      @matched_locale_from_browser = request.preferred_language_from(AvailableLanguage.all.values)
      if signed_in?
        if current_user.locale.blank?
          locale = "en" 
        else
          locale = current_user.locale
        end
      else
        locale = @matched_locale_from_browser
      end
    end
    I18n.locale = locale
  end

end
