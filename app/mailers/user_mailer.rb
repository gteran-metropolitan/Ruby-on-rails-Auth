class UserMailer < ApplicationMailer
  def verification_email(user)
    @user = user
    mail(to: @user.email, subject: "Your Verification Code")
  end
end
