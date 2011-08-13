class CreateAcceptedRecommendations < ActiveRecord::Migration
  def self.up
    create_table :accepted_recommendations do |t|
      t.references :user_origin
      t.references :user_destination
      t.string :movie_id
      t.boolean :added

      t.timestamps
    end
  end

  def self.down
    drop_table :accepted_recommendations
  end
end
