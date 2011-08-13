class WatchlistController < ApplicationController

  def create
    current_user.add_to_watch_list(params[:rt_id])
    render 'create.js.erb'
  end
end

