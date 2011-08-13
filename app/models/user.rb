class User < ActiveRecord::Base
  has_many :authentication_tokens
  has_many :should_watch_movies
  has_many :recommendations
  has_many :i_recommend, :class_name => "AcceptedRecommendation", :foreign_key => "user_origin_id"
  has_many :recommended_to_me, :class_name => "AcceptedRecommendation", :foreign_key => "user_destination_id"

  def self.create_with_omniauth(auth)
    create! do |user|
      user.authentication_tokens.build(:provider => auth["provider"], :uid => auth["uid"])
      user.name = auth["user_info"]["nickname"]
      user.avatar = auth["user_info"]["image"]
    end
  end

  def self.find_by_provider_and_uid(provider, uid)
    if authentication_token = AuthenticationToken.find_by_provider_and_uid(provider, uid)
      authentication_token.user
    end
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
end

