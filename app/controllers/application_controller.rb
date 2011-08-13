class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery
  
  before_filter :count_hit
  
  
  private 
    
    def count_hit
      current_user.hit!
    end
    
end

