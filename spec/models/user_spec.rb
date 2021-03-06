require 'spec_helper'

describe User do

  context "#I should watch" do

    before (:each) do
      m1 = Movie.new(:title => "Rocky I", :year => "1981")
      m2 = Movie.new(:title => "The Godfather", :year => "1978")
      m3 = Movie.new(:title => "Rocky III", :year => "1983")
      @root_user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @root_user.stubs(:should_watch_movies).returns(stub(:not_watched => [ShouldWatchMovie.new(:movie => m1), ShouldWatchMovie.new(:movie => m2)]))
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
      list[0].recommended_to.should == "mati" # nico not diplayed
    end

    it "return one list with accepted recommendation and no accepted" do
      accepted_recommendation = AcceptedRecommendation.new
      accepted_recommendation.user_origin = @user
      accepted_recommendation.user_destination = @user3
      accepted_recommendation.movie = @movie
      accepted_recommendation.added = false
      accepted_recommendation.save!
      @user.i_recommend_list.count.should == 1

      movie2 = Movie.new(:title => "The Godfather", :year => "1978")
      movie2.save!
      movie2.create_recommendation(@user)

      @user.reload
      list = @user.i_recommend_list
      list.count.should == 2
      list[0].recommended_to.should == "mati" # nico not diplayed
      list[0].title.should == "Rocky III"
      list[1].recommended_to.should be nil
      list[1].title.should == "The Godfather"
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
      list[1].recommended_by = "nico" # fer not displayed
    end
  end

  context "#User methods" do
    before (:each) do
      u = User.new
      u.id = 1
      u.name = "ShouldWatch"
      u.save!
    end
    
    it "should return an anonymous user" do
      user = User.anonymous
      user.should_not be_nil
      user.name.should_not be_nil
      user.avatar.should_not be_nil
    end
  end

  context "#Add to Watch List" do
    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user.save!
    end

    it "add a new movie to my watch list" do
      movie = OpenStruct.new(:title => "Fight Club", :year => "1982",
                             :runtime => "240", :synopsis => "",
                             :alternate_ids => OpenStruct.new(:imdb => "1"),
                             :posters => OpenStruct.new(:thumbnail => "a",
                                                       :profile => "b",
                                                       :original => "c",
                                                       :detailed => "d"),
                            :abridged_directors => [OpenStruct.new(:name =>"j")],
                            :genres => ["1","2","ultraviolento"])
      RottenMovie.expects(:find).with(:id => "12132").returns(movie)

      @user.add_to_watch_list("12132")
      movies = @user.i_should_watch_list
      movies.count.should == 1
      movies[0].title.should == "Fight Club"
      movies[0].year.should == "1982"
    end

    it "add an unexisting Rotten Tomatoes movie to my watch list" do
      RottenMovie.expects(:find).with(:id => "42").returns([])

      @user.add_to_watch_list("42")
      @user.i_should_watch_list.count.should == 0
    end

    it "add an existing movie in DB to my watch list" do
      movie = Movie.new(:title => "Fight Club", :year => "1982",
                        :runtime => "240", :plot => "",
                        :rotten_tomatoes_id => "12132")
      movie.save!

      @user.add_to_watch_list("12132")
      movies = @user.i_should_watch_list
      movies.count.should == 1
      movies[0].title.should == "Fight Club"
      movies[0].year.should == "1982"
    end

    it "add an existing movie in my watch list" do
      @user.i_should_watch_list.count.should == 0
      
      movie = Movie.new(:title => "Fight Club", :year => "1982",
                        :runtime => "240", :plot => "",
                        :rotten_tomatoes_id => "12132")
      movie.save!
      @user.add_to_watch_list("12132")
      @user.i_should_watch_list.count.should == 1

      @user.add_to_watch_list("12132")
      @user.i_should_watch_list.count.should == 1
    end
  end

  context "#Accept Recommendation" do
    
    before (:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @user.save!
      @user2 = User.new(:name => "mati", :avatar => "http://www.yahoo.com", :email => "other_none@noneland.com")
      @user2.save!
      @user3 = User.new(:name => "nico", :avatar => "http://www.altavista.com", :email => "another_none@noneland.com")
      @user3.save!
      @movie = Movie.new(:title => "Rocky III", :year => "1983")
      @movie.save!
    end

    it "add a recommendation to my list" do
      r = Recommendation.new(:movie => @movie)
      r.save!
      @user2.recommendations << r
      @user2.save!

      @user.recommended_to_me_list.count.should == 0
      @user.accept_recommendation(r)
      @user.reload
      list = @user.recommended_to_me_list
      list.count.should == 1
      list[0].recommended_by.should == "mati"
    end

    it "add the same recommendation to my list" do
      r = Recommendation.new(:movie => @movie)
      r.save!
      @user2.recommendations << r
      @user2.save!

      @user.recommended_to_me_list.count.should == 0
      @user.accept_recommendation(r)
      @user.reload
      @user.recommended_to_me_list.count.should == 1
      @user.accept_recommendation(r)
      @user.reload
      list = @user.recommended_to_me_list
      list.count.should == 1
      list[0].recommended_by.should == "mati"
    end

    it "add 2 different recommendation of the same movie to my list" do
      r = Recommendation.new(:movie => @movie)
      r.save!
      @user2.recommendations << r
      @user2.save!

      r2 = Recommendation.new(:movie => @movie)
      r2.save!
      @user3.recommendations << r2
      @user3.save!

      @user.recommended_to_me_list.count.should == 0
      @user.accept_recommendation(r)
      @user.reload
      list = @user.recommended_to_me_list
      list.count.should == 1
      list[0].recommended_by.should == "mati"

      @user.accept_recommendation(r2)
      @user.reload
      list = @user.recommended_to_me_list
      list.count.should == 1
      list[0].recommended_by.should == "mati" # nico not displayed
    end

  end

  context "#Update should watch list" do
    before (:each) do
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
    end

    it "reorder the list" do
      list = @user.i_should_watch_list
      list.count.should == 3
      list[0].title.should == "Something about Mary"
      list[1].title.should == "Star Wars I"
      list[2].title.should == "Star Wars II"

      @user.reorder_watch_list(["#{@movie2.id}", "#{@movie1.id}", "#{@movie3.id}"])
      list = @user.i_should_watch_list
      list.count.should == 3
      list[0].title.should == "Star Wars I"
      list[1].title.should == "Something about Mary"
      list[2].title.should == "Star Wars II"
    end

    it "leave the order untouched, no changed" do
      list = @user.i_should_watch_list
      list.count.should == 3
      list[0].title.should == "Something about Mary"
      list[1].title.should == "Star Wars I"
      list[2].title.should == "Star Wars II"

      @user.reorder_watch_list(["#{@movie1.id}", "#{@movie2.id}", "#{@movie3.id}"])
      list = @user.i_should_watch_list
      list.count.should == 3
      list[0].title.should == "Something about Mary"
      list[1].title.should == "Star Wars I"
      list[2].title.should == "Star Wars II"
    end

    it "ignore unexisting id" do
      list = @user.i_should_watch_list
      list.count.should == 3
      list[0].title.should == "Something about Mary"
      list[1].title.should == "Star Wars I"
      list[2].title.should == "Star Wars II"

      @user.reorder_watch_list(["#{@movie2.id}", "#{@movie1.id}", "8829928827","#{@movie3.id}"])
      list = @user.i_should_watch_list
      list.count.should == 3
      list[0].title.should == "Star Wars I"
      list[1].title.should == "Something about Mary"
      list[2].title.should == "Star Wars II"
    end
  end

  context "#My watched List" do

    it "show 2 should watch and 1 have watched" do
      user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      user.save!
      movie1 = Movie.new(:title => "Something about Mary", :year => "1998", :rotten_tomatoes_id => "1")
      movie1.save!
      movie2 = Movie.new(:title => "Star Wars I", :year => "2001", :rotten_tomatoes_id => "2")
      movie2.save!
      user.add_to_watch_list("1")
      user.add_to_watch_list("2")

      movie3 = Movie.new(:title => "Star Wars II", :year => "2004", :rotten_tomatoes_id => "3")
      movie3.save!
      swm = ShouldWatchMovie.create_swm_by_user_and_movie(user, movie3)
      swm.user = user
      swm.watched = true
      swm.save!
      user.reload

      user.should_watch_movies.count.should == 3

      isw = user.i_should_watch_list
      isw.count.should == 2
      isw[0].title.should == "Something about Mary"
      isw[1].title.should == "Star Wars I"

      ihw = user.i_have_watched_list
      user.i_have_watched_count.should == 1
      ihw[0].title.should == "Star Wars II"
    end

    it "show 2 should watch and 0 have watched" do
      user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      user.save!
      movie1 = Movie.new(:title => "Something about Mary", :year => "1998", :rotten_tomatoes_id => "1")
      movie1.save!
      movie2 = Movie.new(:title => "Star Wars I", :year => "2001", :rotten_tomatoes_id => "2")
      movie2.save!
      user.add_to_watch_list("1")
      user.add_to_watch_list("2")

      user.reload

      user.should_watch_movies.count.should == 2 

      isw = user.i_should_watch_list
      isw.count.should == 2
      isw[0].title.should == "Something about Mary"
      isw[1].title.should == "Star Wars I"

      user.i_have_watched_count.should == 0
    end

    it "show 0 should watch and 1 have watched" do
      user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      user.save!

      movie3 = Movie.new(:title => "Star Wars II", :year => "2004", :rotten_tomatoes_id => "3")
      movie3.save!
      swm = ShouldWatchMovie.create_swm_by_user_and_movie(user, movie3)
      swm.user = user
      swm.watched = true
      swm.save!
      user.reload

      user.should_watch_movies.count.should == 1

      isw = user.i_should_watch_list
      isw.count.should == 0

      ihw = user.i_have_watched_list
      user.i_have_watched_count.should == 1
      ihw[0].title.should == "Star Wars II"
    end

    it "change movie from watched to no-watched" do
      user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      user.save!

      movie3 = Movie.new(:title => "Star Wars II", :year => "2004", :rotten_tomatoes_id => "3")
      movie3.save!
      swm = ShouldWatchMovie.create_swm_by_user_and_movie(user, movie3)
      swm.user = user
      swm.watched = true
      swm.save!
      user.reload

      user.should_watch_movies.count.should == 1

      user.i_should_watch_list.count.should == 0
      user.i_have_watched_list.count.should == 1

      user.add_to_watch_list("3")

      user.should_watch_movies.count.should == 1

      user.i_should_watch_list.count.should == 1
      user.i_have_watched_list.count.should == 0
    end
  end
end

