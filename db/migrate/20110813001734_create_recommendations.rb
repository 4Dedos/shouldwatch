class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|
      t.string :movie_id
      t.string :token
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendations
  end
end
