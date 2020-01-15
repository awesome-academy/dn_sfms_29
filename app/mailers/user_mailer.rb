class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail(to: user.email, subject: t(".account_activation_subject")) do |format|
      format.text content_transfer_encoding: "7bit"
      format.html content_transfer_encoding: "7bit"
    end
  end

  def password_reset user
    @user = user
    mail(to: user.email, subject: t(".password_reset_subject")) do |format|
      format.text content_transfer_encoding: "7bit"
      format.html content_transfer_encoding: "7bit"
    end
  end
end
