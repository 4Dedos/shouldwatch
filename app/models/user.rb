class User < ActiveRecord::Base
  has_many :authentication_tokens
  has_many :should_watch_movies
  has_many :recommendations
  has_many :i_recommend, :class_name => "AcceptedRecommendation", :foreign_key => "user_origin_id"
  has_many :recommended_to_me, :class_name => "AcceptedRecommendation", :foreign_key => "user_destination_id"

  def update_with_omniauth(auth)
    self.authentication_tokens.build(:provider => auth["provider"], :uid => auth["uid"])
    self.name = auth["user_info"]["nickname"]
    self.avatar = auth["user_info"]["image"].gsub('normal', 'bigger') if auth["user_info"]["image"]
    self.save
    self
  end

  def self.find_by_provider_and_uid(provider, uid)
    if authentication_token = AuthenticationToken.find_by_provider_and_uid(provider, uid)
      authentication_token.user
    end
  end

  def self.anonymous
    self.create(:name => 'anonymous', :avatar => 'anonymous.jpg ')
  end

  def guest?
    self.authentication_tokens.empty?
  end

  def add_to_watch_list(rt_id)
  end

  def i_should_watch_list
    ret = []
    self.should_watch_movies.each do |swm|
      ret << swm.movie
    end

    return ret
  end

  def recommended_to_me_list
    recommended = self.recommended_to_me.not_added
    recommended.group_by(&:movie).collect do |movie, rtm|
      movie.recommended_by = rtm.map(&:user_origin).map(&:name).join(', ')
      movie
    end 
  end

  def i_recommend_list
    self.i_recommend.group_by(&:movie).collect do |movie, ir|
      movie.recommended_to = ir.map(&:user_destination).map(&:name).join(', ')
      movie
    end
  end
  
  def hit!
    self.hits = (self.hits || 0) + 1
    self.save
  end
  
  def hits
    read_attribute(:hits) || 0
  end
  

  def add_to_watch_list(rotten_tomatoes_id)

    rt_movie = RottenMovie.find(:id => rotten_tomatoes_id)
    movie = Movie.new
    movie.rotten_tomatoes_id = rotten_tomatoes_id
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

    self.should_watch_movies << ShouldWatchMovie.new(:movie => movie)
    self.save!
  end
end

