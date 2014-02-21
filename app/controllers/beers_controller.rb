class BeersController < ApplicationController
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list, :nglist]

  # GET /beers
  # GET /beers.json
  def index
    @beers = Beer.all

    order = params[:order] || 'name'

    case order
      when 'name' then @beers.sort_by!{ |b| b.name }
      when 'brewery' then @beers.sort_by!{ |b| b.brewery.name }
      when 'style' then @beers.sort_by!{ |b| b.style.name }
    end
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @beer = Beer.find(params[:id])
    @rating = Rating.new
    @rating.beer = @beer    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beer }
    end
  end

  def list
  end

  def nglist
  end

  # GET /beers/new
  def new
		@breweries = Brewery.all
    @beer = Beer.new
		@styles = Style.all
  end

  # GET /beers/1/edit
  def edit
    @styles = Style.all
    @breweries = Brewery.all
  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(beer_params)
    @style = Style.find_by_id(params[:style_id])

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beer }
      else
        @styles = Style.all
        @breweries = Brewery.all
        format.html { render action: 'new' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    if current_user.admin
      @beer.destroy
      respond_to do |format|
        format.html { redirect_to beers_url }
        format.json { head :no_content }
      end
    else
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :style_id, :brewery_id)
    end

end
