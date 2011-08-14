class WatchlistController < ApplicationController

  def create
    @movie = current_user.add_to_watch_list(params[:rt_id])
    @want_to_watch = current_user.i_should_watch_list
    render 'create.js.erb'
  end
end

