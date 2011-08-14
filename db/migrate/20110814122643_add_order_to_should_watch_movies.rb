class AddOrderToShouldWatchMovies < ActiveRecord::Migration
  def self.up
    add_column :should_watch_movies, :position, :integer
  end

  def self.down
    remove_column :should_watch_movies, :position
  end
end
