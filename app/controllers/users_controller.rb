class UsersController < ApplicationController

	before_action :current_user, only: [:edit, :show, :update, :destroy]
	before_action :confirm_user, only: [:edit, :show, :update, :destroy]

	def new
		@user = User.new
	end

	def create
		existing = User.find_by_email(params[:user][:email])

		if existing != nil
			flash[:danger] = 'Sorry, that email is already taken.'
			redirect_to new_user_path
		elsif existing == nil
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
				params[:account_create_token] = @user.account_create_token
			else
				flash[:danger] = 'We\'re sorry, there was an error creating your account.'
			end
		end
	end

	def edit
		@user = User.find_by_id(params[:id])
	end

	def show
		@user = User.find(params[:id])

		if @user.auth_token != cookies[:auth_token]
			flash[:danger] = 'You do not have permission to perform that action.'
			redirect_to root_path
		end
	end

	def update
		# if params[:user][:password].length < 1
		# 	flash.now[:danger] = 'Your password cannot be blank.'
		# end

		User.find(params[:id]).update(update_user_params)
		@user = User.find(params[:id])
		render :show
	end

	def destroy
		# 		if Article.destroy_all(user_id: params[:id])
		# 	User.destroy_all(id: params[:id])
		# 	flash[:success] = "You have successfully deleted your account."
		# 	session[:user_id] = nil
		# 	redirect_to login_path
		# else
		# 	flash[:danger] = "Your account was not deleted."
		# 	render :delete
		# end
	end

private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :username)
	end

	def update_user_params
		params.require(:user).permit(:first_name, :last_name, :email, :username, :password)
	end

end