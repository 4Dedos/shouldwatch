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

  context "#I should watch" do
    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user.stubs(:should_watch_movies).returns([ShouldWatchMovie.new(:movie_id => "1"), ShouldWatchMovie.new(:movie_id => "2")])
    end

    it "return a list of movies I should watch" do
      RottenMovie.expects(:find).with(:id => "1").returns(OpenStruct.new({:title => "Rocky I", :year => "1981"}))
      RottenMovie.expects(:find).with(:id => "2").returns(OpenStruct.new({:title => "The Godfather", :year => "1978"}))
      list = @user.i_should_watch_list
      list.count.should == 2
      list[0][:title].should == "Rocky I"
      list[0][:year].should == "1981"
      list[1][:title].should == "The Godfather"
      list[1][:year].should == "1978"
    end
  end

end
