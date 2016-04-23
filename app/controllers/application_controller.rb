class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize
  before_action :current_user

  def current_user
  	@current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  	# memoizing
  end

  helper_method :current_user

  def authorize
    redirect_to login_path unless current_user
  end

  def knock_it_off
    flash[:danger] = 'You do not have permission to perform that action.'
    redirect_to root_path
  end

  def confirm_user
    current_user_id = params[:id] || params[:user_id]
    user = User.try(:find, current_user_id)

    rescue ActiveRecord::RecordNotFound
      knock_it_off
    return

    if user && user.auth_token != cookies[:auth_token]
      knock_it_off
    end
  end

end