class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create
		existing = User.find_by_email(params[:user][:email])

		if existing != nil
			flash[:danger] = "Sorry, that email is already taken."
			redirect_to new_user_path
		elsif existing == nil
			@user = User.create(user_params)

			if @user.save
				session[:username] = @user.username
				redirect_to root_path
			else
				flash.now[:danger] = @user.errors.full_messages
				render :new
			end
		end
	end

	def edit
		if !params[:id]
			flash[:danger] = "You must be logged in to edit your user information."
			redirect_to root_path
		else
			@user = User.find_by_id(params[:id])
		end
	end

	def show
	end

	def update
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

end