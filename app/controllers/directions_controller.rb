class DirectionsController < ApplicationController

	skip_before_action :authorize, only: [:all, :view]
	skip_before_action :current_user, except: [:all, :view]
	before_action :confirm_user, except: [:all, :view]

	def all
		limit = 5
		@directions = Direction.order("published_at DESC").first(limit)
	end

	def view
		@direction = Direction.find(params[:id])
	end

	def index
		@directions = Direction.where(user_id: params[:user_id]).order("published_at DESC")
	end

	def show
		@direction = Direction.find(params[:id])
	end

	def new
		@direction = Direction.new
	end

	def create
		@direction = Direction.new(direction_params)

		if @direction.save
			redirect_to "/directions"
		else
			render :new
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

private

	def direction_params
		params.require(:direction).permit(:title, :body, :published_at)
	end

end