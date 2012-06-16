class IuguMailer < Devise::Mailer
  def template_paths
    "iugu/mailer"
  end
end
