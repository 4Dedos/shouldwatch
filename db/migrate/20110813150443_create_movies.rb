class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :poster
      t.string :title
      t.string :year
      t.string :directors
      t.string :runtime
      t.string :plot
      t.string :links
      t.string :rotten_tomatoes_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
