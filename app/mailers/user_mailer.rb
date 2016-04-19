class UserMailer < ApplicationMailer
	default from: 'support@directionr.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def account_create(user)
  	@user = user

  	mail :to => @user.email, :subject => 'Please confirm your DirectionR account'
  end

  def password_reset(user)
    @user = user

    mail :to => @user.email, :subject => 'DirectionR password reset request'
  end
end