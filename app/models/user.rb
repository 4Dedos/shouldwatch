class User < ActiveRecord::Base
  has_many :authentication_tokens
  has_many :should_watch_movies, :order => 'id DESC'
  has_many :recommendations
  has_many :i_recommend, :class_name => "AcceptedRecommendation", :foreign_key => "user_origin_id"
  has_many :recommended_to_me, :class_name => "AcceptedRecommendation", :foreign_key => "user_destination_id"
  #has_many :movies_i_should_watch, :class_name => "Movie", :through => :should_watch_movies, :source => :movie

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

  def i_should_watch_list
    self.should_watch_movies.collect do |swm|
      swm.movie
    end
    #self.movies_i_should_watch
  end

  def recommended_to_me_list
    recommended = self.recommended_to_me.not_added
    recommended.group_by(&:movie).collect do |movie, rtm|
      movie.recommended_by = rtm.map(&:user_origin).map(&:name).join(', ')
      movie
    end
  end

  def i_recommend_list
    recomm1 = self.i_recommend.group_by(&:movie).collect do |movie, ir|
      movie.recommended_to = ir.map(&:user_destination).map(&:name).join(', ')
      movie
    end

    recomm2 = self.recommendations.map(&:movie)

    recomm1 | recomm2
  end

  def hit!
    self.hits = (self.hits || 0) + 1
    self.save
  end

  def hits
    read_attribute(:hits) || 0
  end


  def add_to_watch_list(rotten_tomatoes_id)
    movie = Movie.find_or_create_by_rt_id(rotten_tomatoes_id)

    return if movie.blank?
    return if self.i_should_watch_list.include?(movie)

    self.should_watch_movies << ShouldWatchMovie.new(:movie => movie)
    self.save!
    movie
  end

  def accept_recommendation(recommendation)
    ar = AcceptedRecommendation.where(:user_origin_id => recommendation.user.id,
                                      :user_destination_id => self.id,
                                      :movie_id => recommendation.movie.id).first
    return if !ar.blank?
    ar = AcceptedRecommendation.new
    ar.movie = recommendation.movie
    ar.user_origin = recommendation.user
    ar.user_destination = self
    ar.added = false
    ar.save!
  end

end

