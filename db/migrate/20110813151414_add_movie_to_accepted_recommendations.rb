class AddMovieToAcceptedRecommendations < ActiveRecord::Migration
  def self.up
    remove_column :accepted_recommendations, :movie_id
    add_column :accepted_recommendations, :movie_id, :integer
  end

  def self.down
    remove_column :accepted_recommendations, :movie_id
    add_column :accepted_recommendations, :movie_id, :string
  end
end
