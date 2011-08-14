class WatchlistController < ApplicationController

  def create
    user = (params[:profile_user] && User.find(params[:profile_user])) || current_user
    @movie = user.add_to_watch_list(params[:rt_id])
    @want_to_watch = user.i_should_watch_list
    render 'create.js.erb'
  end
end

