class RatingsController < ApplicationController
  def index
		@ratings = Rating.all.sort { |r1, r2| r1.beer.name <=> r2.beer.name}
  end

	def new
    @rating = Rating.new
		@beers = Beer.all
  end

	def create
		Rating.create params.require(:rating).permit(:score, :beer_id)
		redirect_to ratings_path
	end

	def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
	end
end

