class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    prepare_params
    settings = session[:user_settings]
    sort = settings[:order] ||= "title"
    @all_ratings = Movie.all_ratings
    @movies  = Movie.order("#{sort} asc")
    @ratings = settings[:ratings] ||= { }
    if @ratings.keys.any?
      @movies = @movies.where(:rating => @ratings.keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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

  def prepare_params
    old_settings = session[:user_settings]
    if incomplete_params?(old_settings)
      params[:order]   ||= old_settings[:order]
      params[:ratings] ||= old_settings[:ratings] if old_settings[:ratings].keys.any?
      store_settings
      redirect_to movies_path(params) and return
    end
    store_settings
  end

  def incomplete_params?(old_settings)
    return false if old_settings.nil?
    return true  if params[:order] != old_settings[:order]
    return false if old_settings[:user_settings].nil?
    return false if old_settings[:order].nil? and (old_settings[:ratings].nil? or old_settings[:ratings].keys.empty?)
    return false if old_settings.nil? or old_settings[:ratings].keys.empty?
    params[:order] != old_settings[:order] or params[:ratings] != old_settings[:ratings]
  end

  def store_settings
    session[:user_settings] = {
      order:   params[:order],
      ratings: params[:ratings]
    }
  end
end
