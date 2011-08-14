class HomeController < ApplicationController

  def index
    prepare_lists
  end

  def welcome
    render :template => '/home/first_visit', :layout => false
  end

  def about
    render :layout => false
  end

end

