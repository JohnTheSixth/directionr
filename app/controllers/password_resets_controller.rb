class PasswordResetsController < ApplicationController

	skip_before_action :authorize
  skip_before_action :current_user

  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	user.send_password_reset if user
  	flash[:success] = 'Please check your email for your password reset instructions.'
  	redirect_to login_path
  end

	def edit
	  @user = User.find_by_password_reset_token!(params[:id])

	  if @user.password_reset_sent_at < 2.hours.ago
	    redirect_to new_password_reset_path, :notice => 'Password reset has expired.'
	  elsif @user.update_attributes(params[:user].permit(:password))
	    redirect_to root_path, :notice => 'Password has been reset!'
	  else
	    render :edit
	  end
	end

	def update
	end

end