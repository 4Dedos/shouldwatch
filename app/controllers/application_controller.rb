class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  before_filter :count_hit
  before_filter :set_popup_template

  private

    def count_hit
      current_user.hit!
    end

    def set_popup_template
      if current_user.hits <= 1
        @popup_template = 'home/first_visit'
      end
    end

    def prepare_lists
      @count_of_watched_movies = current_user.i_have_watched_count
      @want_to_watch = current_user.i_should_watch_list
      @want_to_watch_count = @want_to_watch.size
      @i_recommend = current_user.i_recommend_list
      @recommended_to_me = current_user.recommended_to_me_list
      @recommended_to_me_count = @recommended_to_me.size
    end
end

