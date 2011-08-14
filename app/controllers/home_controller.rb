class HomeController < ApplicationController

  def index
    prepare_lists
  end

  def about
    render :layout => false
  end

end

