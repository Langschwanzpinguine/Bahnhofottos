# Preview all emails at http://localhost:3000/rails/mailers/authentication_mailer
class AuthenticationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/authentication_mailer/reset_password
  def reset_password
    AuthenticationMailer.reset_password
  end

end
