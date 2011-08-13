class User < ActiveRecord::Base
  has_many :authentication_tokens
  has_many :should_watch_movies
  has_many :recommendations
  has_many :i_recommend, :class_name => "AcceptedRecommendation", :foreign_key => "user_origin_id"
  has_many :recommended_to_me, :class_name => "AcceptedRecommendation", :foreign_key => "user_destination_id"
end
