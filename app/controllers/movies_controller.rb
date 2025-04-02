class MoviesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  
  def new
    @movie = Movie.new
  end

  def index
    @movies = Movie.order(created_at: :desc)

    respond_to do |format|
      format.json { render json: @movies }

      format.html
    end
  end

  def show
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.valid?
      @movie.save

      redirect_to movies_url, notice: "Movie was successfully created."
    else
      render "new"
    end
  end

  def edit
  end

  def update
    @movie = Movie.find(params.fetch(:id))

    if @movie.update(movie_params)
      redirect_to @movie, notice: "Movie was successfully updated."
    else
      render "edit"
    end
  end

  def destroy
    @movie = Movie.find(params.fetch(:id))

    @movie.destroy

    redirect_to movies_url, notice: "Movie was successfully destroyed."
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :description, :image_url, :released_on)
  end

  def set_movie
    @movie = Movie.find(params.fetch(:id))
  end
end
