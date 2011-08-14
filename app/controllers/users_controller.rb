class UsersController < ApplicationController
  def show
    prepare_lists
    @profile_user = User.find_by_name!  (params[:id])

    if @profile_user
      @want_to_watch = @profile_user.i_should_watch_list
      @recommended_to_me = @profile_user.recommended_to_me_list
    else
      redirect_to root_path
    end
  end
end

