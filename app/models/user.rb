class User < ActiveRecord::Base
  has_many :authentication_tokens, :dependent => :destroy
  has_many :should_watch_movies, :order => 'position ASC', :dependent => :destroy
  has_many :recommendations, :dependent => :destroy
  has_many :i_recommend, :class_name => "AcceptedRecommendation", :foreign_key => "user_origin_id", :dependent => :destroy
  has_many :recommended_to_me, :class_name => "AcceptedRecommendation", :foreign_key => "user_destination_id", :dependent => :destroy
  #has_many :movies_i_should_watch, :class_name => "Movie", :through => :should_watch_movies, :source => :movie

  def update_with_omniauth(auth)
    self.authentication_tokens.build(:provider => auth["provider"], :uid => auth["uid"], :token => auth['credentials']['token'], :secret => auth['credentials']['secret'])
    self.name = auth["user_info"]["nickname"]
    self.avatar = auth["user_info"]["image"].gsub('normal', 'bigger') if auth["user_info"]["image"]
    debugger
    self.save
    self
  end

  def self.find_by_provider_and_uid(provider, uid)
    if authentication_token = AuthenticationToken.find_by_provider_and_uid(provider, uid)
      authentication_token.user
    end
  end

  def self.anonymous
    anonymous_user = self.create(:name => 'anonymous', :avatar => 'anonymous.jpg ')
    should_watch_user = User.find(1)
    should_watch_user.recommendations.each do |recommendation|
      anonymous_user.accept_recommendation(recommendation)
    end
    anonymous_user.reload
  end

  def guest?
    self.authentication_tokens.empty?
  end

  def has_movies?
    !self.should_watch_movies.empty? || !self.recommended_to_me.empty?
  end

  def i_should_watch_list
    self.should_watch_movies.not_watched.collect do |swm|
      swm.movie
    end
    #self.movies_i_should_watch
  end

  def i_have_watched_list
    self.should_watch_movies.watched.collect do |ihw|
      ihw.movie
    end
  end

  def i_have_watched_count
    self.should_watch_movies.watched.count
  end

  def recommended_to_me_list
    recommended = self.recommended_to_me.not_added
    recommended.group_by(&:movie).collect do |movie, rtm|
      movie.recommended_by = rtm.map(&:user_origin).map(&:name)[0]
      movie
    end
  end

  def i_recommend_list
    recomm1 = self.i_recommend.group_by(&:movie).collect do |movie, ir|
      movie.recommended_to = ir.map(&:user_destination).map(&:name)[0]
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

    if self.i_have_watched_list.include?(movie)
      swm = self.should_watch_movies.where(:movie_id => movie.id).first
      swm.watched = false
      swm.position = self.i_should_watch_list.count + 2
      swm.save!

      self.should_watch_movies.reload
      return movie
    end

    self.should_watch_movies << ShouldWatchMovie.create_swm_by_user_and_movie(self, movie)
    self.save!
    self.should_watch_movies.reload
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

  def reorder_watch_list(movie_list)
    self.should_watch_movies.each do |swm|
      position = movie_list.index(swm.movie.id.to_s)
      next if position.nil?
      swm.position = position + 1
      swm.save!
    end
    self.save!
    self.reload
  end

  def to_param
    self.name
  end
end

