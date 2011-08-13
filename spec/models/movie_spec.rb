require 'spec_helper'

describe Movie do
  context "#find_by_rotten_tomatoes_id" do
    it "return a RT movie" do
      movie = OpenStruct.new(:title => "Fight Club", :year => "1982",
                             :runtime => "240", :synopsis => "",
                             :alternate_ids => OpenStruct.new(:imdb => "1"),
                             :posters => OpenStruct.new(:thumbnail => "a",
                                                       :profile => "b",
                                                       :original => "c",
                                                       :detailed => "d"),
                            :abridged_directors => [OpenStruct.new(:name =>"j")])
      RottenMovie.expects(:find).with(:id => "12132").returns(movie)

      movie = Movie.find_or_create_by_rt_id("12132")
      movie.should_not be nil
      movie.title.should == "Fight Club"
      movie.year.should == "1982"
    end

    it "return a DB movie" do
      movie = Movie.new(:title => "Fight Club", :year => "1982",
                        :runtime => "240", :plot => "",
                        :rotten_tomatoes_id => "12132")
      movie.save!
      
      ret_movie = Movie.find_or_create_by_rt_id("12132")
      ret_movie.should_not be nil
      ret_movie.title.should == "Fight Club"
      ret_movie.year.should == "1982"
    end

    it "return nil movie" do
      RottenMovie.expects(:find).with(:id => "42").returns([])

      movie = Movie.find_or_create_by_rt_id("42")

      movie.should be nil
    end
  end

  context "#create Recommendation" do
    before(:each) do
      @user = User.new(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      @movie = Movie.new(:title => "Fight Club", :year => "1982",
                         :runtime => "240", :plot => "",
                         :imdb_id => "1", :poster_thumbnail => "a",
                         :poster_profile => "b", :poster_original => "c",
                         :poster_detailed => "d", :directors => "j")
      @movie.save!
      @user.save!
    end

    it "return an existing recommendation" do
      recommendation = Recommendation.new(:movie => @movie, :user => @user)
      recommendation.save!

      rec = @movie.create_recommendation(@user)
      rec.id.should == recommendation.id 
    end

    it "create and return a recommendation" do
      Recommendation.count.should == 0

      rec = @movie.create_recommendation(@user)

      rec.should_not be nil

      Recommendation.count.should == 1
    end

    it "return nil becasue there is no user" do
      Recommendation.count.should == 0

      rec = @movie.create_recommendation(nil)

      rec.should be nil

      Recommendation.count.should == 0
    end

  end
end
