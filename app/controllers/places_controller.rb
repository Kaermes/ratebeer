class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingAPI.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_search] = @places.first.city
      render :index
    end
  end

  def show
    @places = BeermappingAPI.places_in(session[:last_search])
    if @places
      @place = @places.select {|x| x.id == params[:id]}.first
      BeermappingAPI.scores_for(@place) 
    else
      render :back
    end
  end

end


