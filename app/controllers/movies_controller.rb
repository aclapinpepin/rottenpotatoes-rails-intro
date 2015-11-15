class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    update_session
    @checked_ratings = checked_ratings
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    @css = 'hilite'
    @all_ratings = Movie.ratings
  end

  def new
    # redirect_to movies_path
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sort
    Movie.where(rating: session[:ratings].keys).order(params[:sort])
  end

  def sorted?
    params[:sort]
  end

  def checked_ratings
    params[:ratings] ? params[:ratings] : {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"}
  end

  def update_session
    session[:ratings] = checked_ratings
    session[:sort] = params[:sort]
  end
end
