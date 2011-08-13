class User < ActiveRecord::Base
  has_many :authentication_tokens
  has_many :should_watch_movies
  has_many :recommendations
  has_many :i_recommend, :class_name => "AcceptedRecommendation", :foreign_key => "user_origin_id"
  has_many :recommended_to_me, :class_name => "AcceptedRecommendation", :foreign_key => "user_destination_id"

  def update_with_omniauth(auth)
    self.authentication_tokens.build(:provider => auth["provider"], :uid => auth["uid"])
    self.name = auth["user_info"]["nickname"]
    self.avatar = auth["user_info"]["image"]
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

  def i_should_watch_list
    ret = []
    should_watch_movies.each do |movie|
      rotten_movie = RottenMovie.find(:id => movie.movie_id)
      movie_hash = {}
      movie_hash[:id] = movie.id
      movie_hash[:title] = rotten_movie.title
      movie_hash[:year] = rotten_movie.year
      ret << movie_hash
    end

    return ret
  end

  def recommended_to_me_list
    ret = []
    recommended_to_me.select{ |m| m.added == false }.each do |movie|
      rotten_movie = RottenMovie.find(:id  => movie.movie_id)
      movie_hash = {}
      movie_hash[:id] = movie.id
      movie_hash[:title] = rotten_movie.title
      movie_hash[:year] = rotten_movie.year
      ret << movie_hash
    end

    return ret
  end

  def i_recommend_list
    ret = []
    i_recommend.each do |movie|
      rotten_movie = RottenMovie.find(:id => movie.movie_id)
      movie_hash = {}
      movie_hash[:id] = movie.id
      movie_hash[:title] = rotten_movie.title
      movie_hash[:year] = rotten_movie.year
      ret << movie_hash
    end

    return ret
  end
end

