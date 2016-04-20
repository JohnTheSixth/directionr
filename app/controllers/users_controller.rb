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
				@user.send_account_create
				flash[:success] = 'Please click on the link in your email to confirm your account.'
				redirect_to root_path
			else
				flash.now[:danger] = @user.errors.full_messages
				render :new
			end
		end
	end

	def edit
		if params[:id] != nil
			# Logging in normally will not match an account creation token in any circumstance.
			@user = User.find_by_account_create_token!(params[:id])

			if @user != nil
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
			else
				# If an account creation token cannot be matched with the param,
				# it will search for a matching user id.
				@user = User.find_by_id(params[:id])
			end
		else
			flash.now[:danger] = "You must be logged in to edit your user information."
			redirect_to root_path
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