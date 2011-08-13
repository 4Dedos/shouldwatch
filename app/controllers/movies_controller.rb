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
end

