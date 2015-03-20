class SessionsController < ApplicationController

	def new
		if current_user
			redirect_to "/users/#{current_user[:id]}/directions"
		end
	end

	def create
		@user = User.find_by_email(params[:loginEmail])

		if @user && @user.authenticate(params[:loginPassword])
			session[:user_id] = @user.id
			redirect_to root_path
		elsif ( params[:loginEmail].length > 0 ) && ( @user == nil )
			flash[:danger] = "That email does not exist."
			redirect_to login_path
		elsif 
			flash[:danger] = "Your email or password is incorrect."
			redirect_to login_path
		end
	end

	def destroy
		session.destroy
		redirect_to root_path
	end

end