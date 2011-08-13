class RecommendationsController < ApplicationController

  def show
    @recommendation = Recommendation.find(params[:id])
    current_user.accept_recomendation(@recommendation)
    @popup_template = 'recommendations/show'
    prepare_lists    
    render :template => 'home/index'
  end

  
end
