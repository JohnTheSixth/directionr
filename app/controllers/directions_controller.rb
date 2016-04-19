class DirectionsController < ApplicationController

	before_filter :authorize

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

private

	def direction_params
		params.require(:direction).permit(:title, :body, :published_at)
	end

end