class CreateShouldWatchMovies < ActiveRecord::Migration
  def self.up
    create_table :should_watch_movies do |t|
      t.references :user
      t.string :movie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :should_watch_movies
  end
end
