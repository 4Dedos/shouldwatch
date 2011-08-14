class RecommendationsController < ApplicationController

  def show
    @recommendation = Recommendation.find(params[:id])
    current_user.accept_recommendation(@recommendation)
    @popup_template = 'recommendations/show'
    prepare_lists
    render :template => 'home/index'
  end

  def create
    @profile_user = User.find(params[:profile_user])

    if @profile_user
      @movie = Movie.find_or_create_by_rt_id(params[:rt_id])
      @recommendation = @movie.create_recommendation(current_user)
      @profile_user.accept_recommendation(@recommendation)

      @recommended_movies = @profile_user.recommended_to_me_list

      redirect_to :controller => 'users', :action => 'show', :id => @profile_user.name and return
    else
      redirect_to root_path
    end
  end
end

