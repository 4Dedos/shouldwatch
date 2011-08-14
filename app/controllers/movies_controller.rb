class MoviesController < ApplicationController

  def search
    @movies = Movie.search_by_name(params[:term])
    render :json => @movies
  end

  def show
    @movie = Movie.find(params[:id])
    render :layout => false
  end

  def destroy
    @should_watch_movie = current_user.should_watch_movies.where(:movie_id => params[:id]).first
    @should_watch_movie.destroy

    redirect_to root_path, :notice => "The movie was removed."
  end

  def recommend
    @movie = Movie.find(params[:id])
    @recommendation = @movie.create_recommendation(current_user)
  end

  def order
    movies_order = params[:movies_order]
    new_order = movies_order.split(',').collect do |movie_id|
      movie_id.split('_')[1]
    end

    current_user.reorder_watch_list(new_order)
    render :json => {:ok => "true"}
  end

  def watch_this
    @should_watch_movie = current_user.should_watch_movies.where(:movie_id => params[:id]).first
    @should_watch_movie.update_attribute(:watched, true)

    redirect_to root_path, :notice => "Congratulations! You have watched #{@should_watch_movie.movie.title}."
  end
end

