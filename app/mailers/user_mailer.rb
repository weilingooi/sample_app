class UserMailer < ApplicationMailer
  def account_activation user
    @data = {
      user: user,
    }
    mail to: user.email, subject: t(".acc_active")
  end

  def password_reset
    @data = {
      user: user,
    }
    mail to: user.email, subject: t("sessions.forgot_password.title")
  end
end
