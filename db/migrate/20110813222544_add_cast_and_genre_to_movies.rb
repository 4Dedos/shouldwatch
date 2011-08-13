class AddCastAndGenreToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :cast, :string
    add_column :movies, :genres, :string
  end

  def self.down
    remove_column :movies, :cast
    remove_column :movies, :genres
  end
end
