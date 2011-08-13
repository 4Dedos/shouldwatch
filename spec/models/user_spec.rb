require 'spec_helper'

describe User do
  context "#I recommend" do
    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user2 = User.new(:name => "mati", :avatar => "http://www.yahoo.com", :email => "other_none@noneland.com")
    end
    
    it "return a list of movies that I recommend" do
      accepted_recommendation = AcceptedRecommendation.new
      accepted_recommendation.user_origin = @user
      accepted_recommendation.user_destination = @user2
      accepted_recommendation.movie_id = "gone_with_the_wind"
      accepted_recommendation.added = false
      accepted_recommendation.save!

      @user.i_recommend.count.should == 1
      @user.i_recommend[0].movie_id.should == "gone_with_the_wind"
      @user2.recommended_to_me.count.should == 1
      @user2.recommended_to_me[0].movie_id.should == "gone_with_the_wind"
    end
  end

end
