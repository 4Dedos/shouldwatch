class ShouldWatchMovie < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user

  scope :watched, where(:watched => true)
  scope :not_watched, where(:watched => false)

  def self.create_swm_by_user_and_movie(user, movie)
    swm = ShouldWatchMovie.where(:user_id => user.id, :movie_id => movie.id).first
   
    if swm.blank?
      swm = ShouldWatchMovie.new(:movie => movie) if swm.blank?
      swm.position = ShouldWatchMovie.where(:user_id => user.id).count + 1
    end 

    return swm
  end
end
