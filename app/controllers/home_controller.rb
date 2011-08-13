class HomeController < ApplicationController

  def index
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
