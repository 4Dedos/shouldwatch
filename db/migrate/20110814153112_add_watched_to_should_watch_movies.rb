class AddWatchedToShouldWatchMovies < ActiveRecord::Migration
  def self.up
    change_table :should_watch_movies do |t|
      t.boolean :watched, :default => false
    end
  end

  def self.down
    remove_column :should_watch_movies, :watched
  end
end
