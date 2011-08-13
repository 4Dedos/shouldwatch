class HomeController < ApplicationController

  def index
    @want_to_watch = [
        "The Shawshank Redemption (1994)",
        "The Godfather (1972)",
        "The Godfather: Part II (1974)",
        "The Good, the Bad and the Ugly (1966)",
        "Pulp Fiction (1994)",
        "12 Angry Men (1957)",
        "Schindler's List (1993)",
        "One Flew Over the Cuckoo's Nest (1975)",
        "Inception (2010)",
        "The Dark Knight (2008)",
        "The Lord of the Rings: The Return of the King (2003)"
    ].collect{|m| Movie.new(:title => m)}

    @i_recommend = @want_to_watch
    @recommended_to_me = @want_to_watch
  end

  def first_visit
    render :layout => false
  end

  def welcome_guest
    render :layout => false
  end

  def movie_description
  end

end

