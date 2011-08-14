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

  def reject_recommendation
    @recomendation_to_me = current_user.recommended_to_me.not_added.first(:conditions => {:movie_id => params[:id]})
    @movie = @recomendation_to_me.movie
    @recomendation_to_me.destroy
    @recommended_to_me = current_user.recommended_to_me_list
  end

  def accept_recommendation
    @recomendation_to_me = current_user.recommended_to_me.not_added.first(:conditions => {:movie_id => params[:id]})
    if @recomendation_to_me
      @movie = @recomendation_to_me.movie
      current_user.add_to_watch_list(@movie.rotten_tomatoes_id)
      @recomendation_to_me.update_attribute(:added, true)
      @want_to_watch = current_user.i_should_watch_list
      @recommended_to_me = current_user.recommended_to_me_list
    end
  end

  def watch_this
    @should_watch_movie = current_user.should_watch_movies.where(:movie_id => params[:id]).first
    @should_watch_movie.update_attribute(:watched, true)
    @trigger_movie = @should_watch_movie.movie
    redirect_to root_path, :notice => "Congratulations! You have watched #{@should_watch_movie.movie.title}."
  end
end

