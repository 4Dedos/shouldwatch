class AcceptedRecommendation < ActiveRecord::Base
  belongs_to :user_origin, :class_name => "User"
  belongs_to :user_destination, :class_name => "User"
  belongs_to :movie

  scope :not_added, where(:added => false)
end
