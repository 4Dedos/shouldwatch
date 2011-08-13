class AddDetailedInformationToMovies < ActiveRecord::Migration
  def self.up
    remove_column :movies, :poster
    add_column :movies, :poster_thumbnail, :string
    add_column :movies, :poster_profile, :string
    add_column :movies, :poster_original, :string
    add_column :movies, :poster_detailed, :string
    add_column :movies, :imdb_id, :string
  end

  def self.down
    remove_column :movies, :imdb_id
    remove_column :movies, :poster_thumbnail
    remove_column :movies, :poster_profile
    remove_column :movies, :poster_original
    remove_column :movies, :poster_detailed
    add_column :movies, :poster, string
  end
end
