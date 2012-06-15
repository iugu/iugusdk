class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: "envio@iugu.com.br",
          reply: "ajuda@iugu.com.br"

  def confirmation_instructions(record)
    devise_mail(record, :confirmation_instructions)
  end

  def reset_password_instructions(record)
    devise_mail(record, :reset_password_instructions)
  end

  def unlock_instructions(record)
    devise_mail(record, :unlock_instructions)
  end

  def template_paths
    "iugu/user_mailer"
  end

end
