class MoviesController < ApplicationController

  def search
    #movie = { :thumb => 'http://i.media-imdb.com/images/mobile/film-40x54.png',
    #          :label => 'The Life Aquatic with Steve Zissou',
    #          :extra => '(2008)',
    #          :detail => 'Bill Murray, Owen Wilson',
    #          :id => 'XVKS' }
    @movies = Movie.search_by_name(params[:term])
    render :json => @movies
  end

  def show
    @movie = Movie.find(params[:id])
    render :layout => false
  end

  def destroy
    @should_watch_movie = ShouldWatchMovie.where(:movie_id => params[:id]).first
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

    #current_user.update_should_watch_list(new_order)
    render :json => {:ok => "true"}
  end
end

