class Movie < ActiveRecord::Base
  attr_accessor :recommended_by, :recommended_to

  def self.find_by_rotten_tomatoes_id(rotten_tomatoes_id)
    movie = Movie.where(:rotten_tomatoes_id => rotten_tomatoes_id).first

    if movie.blank?
      rt_movie = RottenMovie.find(:id => rotten_tomatoes_id)
      if !rt_movie.blank?
        movie = rotten_tomatoes_to_movie(rt_movie)
      end
    end

    return movie
  end

  def create_recommendation(user)
    return if user.blank?
    recommendation = Recommendation.where(:user_id => user.id, :movie_id => self.id).first

    if recommendation.blank?
      recommendation = Recommendation.new
      recommendation.user = user
      recommendation.movie = self
      recommendation.save!
    end

    return recommendation
  end

  private

  def self.rotten_tomatoes_to_movie(rt_movie)
    movie = Movie.new
    movie.rotten_tomatoes_id = rt_movie.id
    movie.title = rt_movie.title
    movie.year = rt_movie.year
    movie.runtime = rt_movie.runtime
    movie.plot = rt_movie.synopsis
    movie.imdb_id = rt_movie.alternate_id.imdb
    movie.poster_thumbnail = rt_movie.posters.thumbnail
    movie.poster_profile = rt_movie.posters.profile
    movie.poster_original = rt_movie.posters.original
    movie.poster_detailed = rt_movie.posters.detailed
    movie.directors = rt_movie.abridged_directors.map(&:name).join(', ')
    movie.save!

    return movie
  end
end
