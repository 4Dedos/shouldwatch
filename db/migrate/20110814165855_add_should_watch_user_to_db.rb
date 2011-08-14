class AddShouldWatchUserToDb < ActiveRecord::Migration
  def self.up
    u = User.where(:id => 1).first
    u.destroy if !u.blank?
    
    should_watch_user = User.new
    should_watch_user.id = 1
    should_watch_user.name = "ShouldWatch"
    should_watch_user.avatar = "http://a3.twimg.com/sticky/default_profile_images/default_profile_4_bigger.png"
    should_watch_user.save!

    authentication_token = AuthenticationToken.new
    authentication_token.uid = "354284354"
    authentication_token.provider = "twitter"
    authentication_token.user = should_watch_user
    authentication_token.save!

    movie_life_aquatic = Movie.find_or_create_by_rt_id("12895")
    movie_high_fidelity = Movie.find_or_create_by_rt_id("12937")
    movie_boogie_night = Movie.find_or_create_by_rt_id("14134")
    movie_clerks = Movie.find_or_create_by_rt_id("13148")
    movie_critters = Movie.find_or_create_by_rt_id("11513")

    recommend_life_aquatic = Recommendation.new(:user => should_watch_user,
                                                :movie => movie_life_aquatic)
    recommend_life_aquatic.save!
    recommend_hight_fidelity = Recommendation.new(:user => should_watch_user,
                                              :movie => movie_high_fidelity)
    recommend_hight_fidelity.save!
    recommend_boogie_night = Recommendation.new(:user => should_watch_user,
                                                :movie => movie_boogie_night)
    recommend_boogie_night.save!
    recommend_clerks = Recommendation.new(:user => should_watch_user,
                                          :movie => movie_clerks)
    recommend_clerks.save!
    recommend_critters = Recommendation.new(:user => should_watch_user,
                                            :movie => movie_critters)
    recommend_critters.save!
  end

  def self.down
  end
end
