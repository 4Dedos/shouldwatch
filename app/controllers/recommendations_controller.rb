class RecommendationsController < ApplicationController

  def show
    prepare_lists
    @recommendation = Recommendation.new
    @popup_template = 'recommendations/show'
    render :template => 'home/index'
  end

  
end
