class IuguMailer < Devise::Mailer

  default from: "Iugu <equipe@iugu.com.br>",
          reply_to: "Iugu <atendimento@iugu.com.br>"

  def template_paths
    "iugu/mailer"
  end

  def invitation(user_invitation)
    @user_invitation = user_invitation
    mail(to: @user_invitation.email, :subject => "Convite para sua conta") do |format|
      format.html { render "iugu/mailer/invitation" }
    end
  end
end
