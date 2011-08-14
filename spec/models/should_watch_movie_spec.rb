require 'spec_helper'

describe ShouldWatchMovie do
  context "#create swm by user and movie" do
    before(:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user.save!
      @movie1 = Movie.new(:title => "Something about Mary", :year => "1998", :rotten_tomatoes_id => "1")
      @movie1.save!
      @movie2 = Movie.new(:title => "Star Wars I", :year => "2001", :rotten_tomatoes_id => "2")
      @movie2.save!
      @movie3 = Movie.new(:title => "Star Wars II", :year => "2004", :rotten_tomatoes_id => "3")
      @movie3.save!
      @user.add_to_watch_list("1")
      @user.add_to_watch_list("2")
      @user.add_to_watch_list("3")
      @user.reload

      @swm = ShouldWatchMovie.new
      @swm.movie = @movie1
      @swm.position = 1
      @swm.id = 1
      @swm.user = @user
      @swm.save!
    end

    it "return an existing swm" do
      ShouldWatchMovie.expects(:where).with(:user_id => @user.id, :movie_id => @movie1.id).returns(stub(:first => @swm))

      swm = ShouldWatchMovie.create_swm_by_user_and_movie(@user, @movie1)
      swm.should_not be nil
      swm.movie.should == @movie1
      swm.position.should == @swm.position
      swm.id.should == @swm.id
    end

    it "return a new swm" do
      ShouldWatchMovie.expects(:where).with(:user_id => @user.id, :movie_id => @movie1.id).returns(stub(:first => nil))
      ShouldWatchMovie.expects(:where).with(:user_id => @user.id).returns(stub(:count => 1))

      swm = ShouldWatchMovie.create_swm_by_user_and_movie(@user, @movie1)
      swm.should_not be nil
      swm.id.should be nil
      swm.movie.should == @movie1
      swm.position.should == 2
    end

  end
end
