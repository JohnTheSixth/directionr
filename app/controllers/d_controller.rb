class DController < ApplicationController

	skip_before_action :authorize
	skip_before_action :current_user
	skip_before_action :confirm_user

	def show
		@direction = Direction.find_by_short_url(params[:id])
	end

end