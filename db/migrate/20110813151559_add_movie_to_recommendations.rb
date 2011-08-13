class AddMovieToRecommendations < ActiveRecord::Migration
  def self.up
    remove_column :recommendations, :movie_id
    add_column :recommendations, :movie_id, :integer
  end

  def self.down
    remove_column :recommendations, :movie_id
    add_column :recommendations, :movie_id, :string
  end
end
