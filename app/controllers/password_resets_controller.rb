class PasswordResetsController < ApplicationController

	skip_before_action :authorize
  skip_before_action :current_user

  def new
  end

  def create
  	if params[:email].match(/\@/) == nil
  		flash[:danger] = 'Please enter a valid email address.'
  		render :new
  	else
	  	user = User.find_by_email(params[:email])
			user.send_password_reset if user
			flash[:success] = 'If your email address exists in our records, you will receive your password reset instructions.'
			redirect_to login_path
		end
  end

	def edit
	  @user = User.find_by_password_reset_token!(params[:id])

	  if @user.password_reset_sent_at < 2.hours.ago
			flash[:danger] = 'Your password reset has expired. Please request a new reset email.'
	  	redirect_to new_password_reset_path
	  else
	    render :edit
	  end
	end

	def update
		@user = User.find_by_password_reset_token!(params[:id])

		if @user.update_attributes(password_update_params)
	  	redirect_to root_path
	  	flash[:info] = 'Your password has been reset!'
	  else
	  	flash[:danger] = @user.errors.full_messages
	  	render :edit
	  end
	end

private

	def password_update_params
		params.require(:user).permit(:password, :password_confirmation)
	end

end