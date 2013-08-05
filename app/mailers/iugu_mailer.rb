class IuguMailer < Devise::Mailer

  default from: "Iugu <no-reply@iugu.com>",
          reply_to: "Iugu <no-reply@iugu.com>"

  def template_paths
    "iugu/mailer"
  end

  def reset_password_instructions(record, opts={})
    set_locale(record)
    super(record)
    set_default_locale
  end

  def invitation(user_invitation)
    user = User.find(user_invitation.invited_by)
    set_locale(user)
    @user_invitation = user_invitation
    mail(to: @user_invitation.email, :subject => I18n.t("emails.user_invitation", account_name: @user_invitation.account.try(:name))) do |format|
      format.html { render "iugu/mailer/invitation" }
    end
    set_default_locale
  end

  def welcome(user)
    set_locale(user)
    @user = user
    mail(to: @user.email, :subject => I18n.t("emails.user_welcome", application_title: IuguSDK::application_title)) do |format|
      format.html { render "iugu/mailer/welcome" }
    end
    set_default_locale
  end

  private

  def set_locale(user)  
    @default_locale = I18n.locale 
    I18n.locale = user.locale
  end

  def set_default_locale
    I18n.locale = @default_locale
  end
end
