class AddMovieToShouldWatchMovies < ActiveRecord::Migration
  def self.up
    remove_column :should_watch_movies, :movie_id
    add_column :should_watch_movies, :movie_id, :integer
  end

  def self.down
    remove_column :should_watch_movies, :movie_id
    add_column :should_watch_movies, :movie_id, :string
  end
end
