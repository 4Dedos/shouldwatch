class HomeController < ApplicationController

  def index
    @want_to_watch = current_user.i_should_watch_list
    @i_recommend = current_user.i_recommend_list
    @recommended_to_me = current_user.recommended_to_me_list
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

