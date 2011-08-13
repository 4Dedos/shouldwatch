require 'spec_helper'

describe Movie do
  context "#find_by_rotten_tomatoes_id" do
    it "return a RT movie" do
      movie = OpenStruct.new(:title => "Fight Club", :year => "1982",
                             :runtime => "240", :synopsis => "",
                             :alternate_id => OpenStruct.new(:imdb => "1"),
                             :posters => OpenStruct.new(:thumbnail => "a",
                                                       :profile => "b",
                                                       :original => "c",
                                                       :detailed => "d"),
                            :abridged_directors => [OpenStruct.new(:name =>"j")])
      RottenMovie.expects(:find).with(:id => "12132").returns(movie)

      movie = Movie.find_by_rotten_tomatoes_id("12132")
      movie.should_not be nil
      movie.title.should == "Fight Club"
      movie.year.should == "1982"
    end

    it "return a DB movie" do
      movie = Movie.new(:title => "Fight Club", :year => "1982",
                        :runtime => "240", :plot => "",
                        :rotten_tomatoes_id => "12132")
      movie.save!
      
      ret_movie = Movie.find_by_rotten_tomatoes_id("12132")
      ret_movie.should_not be nil
      ret_movie.title.should == "Fight Club"
      ret_movie.year.should == "1982"
    end

    it "return nil movie" do
      RottenMovie.expects(:find).with(:id => "42").returns([])

      movie = Movie.find_by_rotten_tomatoes_id("42")

      movie.should be nil
    end
  end
end
