class MoviesController < ApplicationController

  def search
    movie = { :thumb => 'http://i.media-imdb.com/images/mobile/film-40x54.png',
              :label => 'The Life Aquatic with Steve Zissou',
              :extra => '(2008)',
              :detail => 'Bill Murray, Owen Wilson',
              :id => 'XVKS' }

    render :json => 3.times.collect{ movie }
  end

end

