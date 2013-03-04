module IuguSDKBaseController

  def self.included(receiver)
    receiver.append_before_filter :configure_locale
  end

  def select_account
    set_account(current_user) if current_user
  end

  def http_preferred_languages(header)
    @user_preferred_languages ||= header.split(/\s*,\s*/).collect do |l|
      if l =~ /\?\?\?/i
        ["none",0] 
      else
        l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
      end
    end.sort do |x,y|
      raise "Not correctly formatted" unless x.first =~ /^[a-z\-]+$/i
      y.last.to_f <=> x.last.to_f
    end.collect do |l|
      l.first.downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
    end
  rescue Exception => e
    []
  end

  def preferred_language_from(array, http_accepted_languages)
    (http_preferred_languages(http_accepted_languages) & array.collect { |i| i.to_s }).first
  end

  def get_compatible_locale(http_accepted_languages)
    preferred_language_from( AvailableLanguage.all.values, http_accepted_languages)
  end

  def configure_locale
    if(params[:hl])
      locale = params[:hl] if AvailableLanguage.all.values.include? params[:hl]
    end
    unless locale
      @matched_locale_from_browser = get_compatible_locale( request.env['HTTP_ACCEPT_LANGUAGE'] ) 
      if user_signed_in?
        if current_user.locale.blank?
          locale = "en" 
        else
          locale = current_user.locale
        end
      else
        locale = @matched_locale_from_browser
      end
    else
      @matched_locale_from_browser = locale
    end
    I18n.locale = locale
  end

  def verify_api_key
    raise ActionController::RoutingError.new("iws_api_key missing") unless IuguSDK::iws_api_key
  end

  def locale_to_currency(locale)
    {
      'pt-BR' => "BRL",
      'en'    => "USD"
    }[locale.to_s]
  end

end
