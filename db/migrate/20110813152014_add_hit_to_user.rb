class AddHitToUser < ActiveRecord::Migration
  
  def self.up
    add_column :users, :hits, :integer
  end

  def self.down
    remove_column :users, :hits
  end
end
