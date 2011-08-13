require 'spec_helper'

describe User do
  before (:each) do
    m1 = Movie.new(:title => "Rocky I", :year => "1981")
    m2 = Movie.new(:title => "The Godfather", :year => "1978")
    m3 = Movie.new(:title => "Rocky III", :year => "1983")
    @root_user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
    @root_user.stubs(:should_watch_movies).returns([ShouldWatchMovie.new(:movie => m1), ShouldWatchMovie.new(:movie => m2)])
    @root_user.stubs(:recommended_to_me).returns([AcceptedRecommendation.new(:movie => m1, :added => false), AcceptedRecommendation.new(:movie => m2, :added => false), AcceptedRecommendation.new(:movie => m3, :added => true)])
  end

  context "#I recommend" do
    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user2 = User.new(:name => "mati", :avatar => "http://www.yahoo.com", :email => "other_none@noneland.com")
    end

    before (:each) do
      accepted_recommendation = AcceptedRecommendation.new
      accepted_recommendation.user_origin = @user
      accepted_recommendation.user_destination = @user2
      accepted_recommendation.movie = Movie.new(:title => "Rocky III", :year => "1983") 
      accepted_recommendation.added = false
      accepted_recommendation.save!
    end

    it "return a list of movies that I recommend (plain)" do
      @user.i_recommend.count.should == 1
      @user.i_recommend[0].movie.title.should == "Rocky III"
      @user2.recommended_to_me.count.should == 1
      @user2.recommended_to_me[0].movie.title.should == "Rocky III"
    end

    it "return a list of movies that I recommend (extended)" do
      list = @user.i_recommend_list
      list.count.should == 1
      list[0].title.should == "Rocky III"
      list[0].year.should == "1983"
    end
  end

  context "#I should watch" do
    before (:each) do
    end

    it "return a list of movies I should watch" do
      list = @root_user.i_should_watch_list
      list.count.should == 2
      list[0].title.should == "Rocky I"
      list[0].year.should == "1981"
      list[1].title.should == "The Godfather"
      list[1].year.should == "1978"
    end
  end

  context "#My friends recommend" do
    before (:each) do
    end

    it "return a list of movies My Friends recommend" do
      list = @root_user.recommended_to_me_list
      list.count.should == 2
      list[0].title.should == "Rocky I"
      list[0].year.should == "1981"
      list[1].title.should == "The Godfather"
      list[1].year.should == "1978"
    end
  end

  context "#User methods" do
    it "should return an anonymous user" do
      user = User.anonymous
      user.should_not be_nil
      user.name.should_not be_nil
      user.avatar.should_not be_nil
    end
  end
end

