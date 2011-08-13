require 'spec_helper'

describe User do

  context "#I should watch" do

    before (:each) do
      m1 = Movie.new(:title => "Rocky I", :year => "1981")
      m2 = Movie.new(:title => "The Godfather", :year => "1978")
      m3 = Movie.new(:title => "Rocky III", :year => "1983")
      @root_user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @root_user.stubs(:should_watch_movies).returns([ShouldWatchMovie.new(:movie => m1), ShouldWatchMovie.new(:movie => m2)])
      @root_user.stubs(:recommended_to_me).returns([AcceptedRecommendation.new(:movie => m1, :added => false), AcceptedRecommendation.new(:movie => m2, :added => false), AcceptedRecommendation.new(:movie => m3, :added => true)])
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

  
  context "Counting hits" do
    
    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
    end
    
    it "should increment counter on :hit!" do
      @user.hits.should be_eql(0)
      @user.hit!
      @user.hits.should be_eql(1)
      3.times { @user.hit! }
      @user.hits.should be_eql(4)      
    end
    
  end
  
  context "#I recommend" do

    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user2 = User.new(:name => "mati", :avatar => "http://www.yahoo.com", :email => "other_none@noneland.com")
      @user3 = User.new(:name => "nico", :avatar => "http://www.altavista.com", :email => "another_none@noneland.com")
      @user4 = User.new(:name => "fer", :avatar => "http://www.bing.com", :email => "last_none@noneland.com")
    end

    before (:each) do
      @movie = Movie.new(:title => "Rocky III", :year => "1983")
      @movie.save!
      accepted_recommendation = AcceptedRecommendation.new
      accepted_recommendation.user_origin = @user
      accepted_recommendation.user_destination = @user2
      accepted_recommendation.movie = @movie
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

    it "return one movie recommended twice" do
      accepted_recommendation = AcceptedRecommendation.new
      accepted_recommendation.user_origin = @user
      accepted_recommendation.user_destination = @user3
      accepted_recommendation.movie = @movie
      accepted_recommendation.added = false
      accepted_recommendation.save!

      list = @user.i_recommend_list
      list.count.should == 1
      list[0].recommended_to.should == "mati, nico"
    end
  end
  
  context "#My friends recommend" do

    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user2 = User.new(:name => "mati", :avatar => "http://www.yahoo.com", :email => "other_none@noneland.com")
      @user3 = User.new(:name => "nico", :avatar => "http://www.altavista.com", :email => "another_none@noneland.com")
      @user4 = User.new(:name => "fer", :avatar => "http://www.bing.com", :email => "last_none@noneland.com")
    end

    before (:each) do
      movie = Movie.new(:title => "Rocky I", :year => "1981")
      movie.save!
      accepted_recommendation = AcceptedRecommendation.new
      accepted_recommendation.user_origin = @user2
      accepted_recommendation.user_destination = @user
      accepted_recommendation.movie = movie
      accepted_recommendation.added = false
      accepted_recommendation.save!
    end

    before (:each) do
      movie = Movie.new(:title => "The Godfather", :year => "1978")
      movie.save!
      accepted_recommendation = AcceptedRecommendation.new(:user_origin => @user3, :user_destination => @user, :movie => movie, :added => false)
      accepted_recommendation.save!
      accepted_recommendation = AcceptedRecommendation.new(:user_origin => @user4, :user_destination => @user, :movie => movie, :added => true)
      accepted_recommendation.save!
    end

    it "return a list of movies My Friends recommend" do
      list = @user.recommended_to_me_list
      list.count.should == 2
      list[0].title.should == "Rocky I"
      list[0].year.should == "1981"
      list[0].recommended_by = "mati"
      list[1].title.should == "The Godfather"
      list[1].year.should == "1978"
      list[1].recommended_by = "nico, fer"
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

