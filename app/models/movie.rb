class Movie < ActiveRecord::Base
  attr_accessor :recommended_by, :recommended_to

  def self.search_by_name(name, limit = 10)
    movies = RottenMovie.find(:title => name, :limit => limit)
    if(movies.is_a? Array)
      movies.map { |movie| [movie.id, "#{movie.title} (#{movie.year})"] }
    elsif(movies.is_a? PatchedOpenStruct)
      [movie.id, "#{movies.title} (#{movies.year})"]
    else
      raise "There was a type error on the returned result set."
    end

    movies.collect{|m| {
      :id => m.id,
      :title => m.title,
      :year => ("(#{m.year})" if m.year),
      :image => m.posters.thumbnail,
      :detail => 'Details...'}}
  end

  def self.find_or_create_by_rt_id(rotten_tomatoes_id)
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
    movie.imdb_id = rt_movie.alternate_ids.imdb
    movie.poster_thumbnail = rt_movie.posters.thumbnail
    movie.poster_profile = rt_movie.posters.profile
    movie.poster_original = rt_movie.posters.original
    movie.poster_detailed = rt_movie.posters.detailed
    movie.directors = rt_movie.abridged_directors.map(&:name).join(', ')
    if !rt_movie.abridged_cast.blank?
      movie.cast = rt_movie.abridged_cast.map(&:name).join(', ')
    end
    movie.genres = rt_movie.genres.join(', ')
    movie.save!

    return movie
  end
end

