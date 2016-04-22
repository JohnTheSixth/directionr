class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
  	@current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  	# memoizing
  end

  helper_method :current_user

  def authorize
    redirect_to login_path unless current_user
  end

  def confirm_user
    @user = User.find(params[:id])
    
    if @user.auth_token != cookies[:auth_token]
      flash[:danger] = 'You do not have permission to perform that action.'
      redirect_to root_path
    end
  end

end