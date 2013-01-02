class IuguMailer < Devise::Mailer

  default from: "iugu <do-not-respond@iugu.com>",
          reply_to: "iugu <do-not-respond@iugu.com>"

  def template_paths
    "iugu/mailer"
  end

  def invitation(user_invitation)
    @user_invitation = user_invitation
    mail(to: @user_invitation.email, :subject => "Convite para sua conta") do |format|
      format.html { render "iugu/mailer/invitation" }
    end
  end

  def welcome(user)
    @user = user
    mail(to: @user.email, :subject => "Bem vindo!") do |format|
      format.html { render "iugu/mailer/welcome" }
    end
  end
end
