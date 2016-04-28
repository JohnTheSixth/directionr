class UsersController < ApplicationController

	skip_before_action :authorize, only: [:new, :create, :confirm, :deny]
	skip_before_action :current_user, only: [:new, :create, :confirm, :deny]
	before_action :confirm_user, only: [:edit, :show, :update, :destroy]

	def new
		@user = User.new
	end

	def create
		existing_email = User.find_by_email(params[:user][:email])
		existing_uname = User.find_by_username(params[:user][:username])

		if existing_email != nil
			flash[:danger] = 'Sorry, that email is already taken.'
			redirect_to new_user_path
		elsif existing_uname != nil
			flash[:danger] = 'Sorry, that username is already taken.'
			redirect_to new_user_path
		elsif existing_email == nil && existing_uname == nil
			@user = User.create(user_params)

			if @user.save
				@user.send_account_create
				flash[:success] = 'Please click on the link in your email to confirm your account.'
				redirect_to root_path
			else
				flash.now[:danger] = @user.errors.full_messages
				render :new
			end
		end
	end

	def confirm
		@user = User.find_by_account_create_token!(params[:id])

		if @user.account_create_confirmed_at != nil
			flash.now[:info] = 'You have already confirmed your account.'
		else
			@user.account_create_confirmed_at = Time.zone.now

			if @user.save
				cookies[:auth_token] = @user.auth_token
				params[:account_create_token] = @user.account_create_token
			else
				flash[:danger] = 'We\'re sorry, there was an error creating your account.'
			end
		end
	end

	def deny
		@user = User.find_by_account_create_token!(params[:id])

		if @user.account_create_confirmed_at == nil
			if @user.destroy
				flash[:info] = 'The account associated with this email has been deleted. We apologize for the error.'
				redirect_to root_path
			else
				flash[:danger] = 'There was an error deleting the account associated with your email. Please contact support.'
			end
		else
			flash.now[:info] = 'The account associated with this email has already been confirmed. It can only be deleted by the authorized user.'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def show
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])

		if update_user_params[:current_password].length == 0
			flash.now[:danger] = 'Please enter your password to update your information.'
			render :edit
		elsif @user.authenticate(update_user_params[:current_password]) != @user
			flash.now[:danger] = 'The password you entered does not match the current account password.'
			render :edit
		elsif @user.authenticate(update_user_params[:current_password]) == @user
			if @user.update_attributes(update_user_params.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation))
				render :show
			else
				flash.now[:danger] = @user.errors.full_messages
				render :edit
			end
		end
	end

	def destroy
		@user = User.find(params[:id])

		if delete_user_params[:current_password].length == 0
			flash.now[:danger] = 'Please enter your password to delete your account.'
			render :show
		elsif @user.authenticate(delete_user_params[:current_password]) != @user
			flash.now[:danger] = 'The password you entered does not match the current account password.'
			render :show
		elsif @user.authenticate(delete_user_params[:current_password]) == @user
			if User.destroy_all(id: params[:id])
				flash[:success] = 'You have successfully deleted your account.'
				session[:id] = nil
				cookies[:auth_token] = nil
				redirect_to root_path
			else
				flash[:danger] = 'Your account was not deleted.'
				render :edit
			end
		end
	end

private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
	end

	def update_user_params
		params.require(:user).permit(:first_name, :last_name, :email, :username, :current_password, :password, :password_confirmation)
	end

	def delete_user_params
		params.require(:user).permit(:current_password)
	end
end