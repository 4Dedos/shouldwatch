class CreateAuthenticationTokens < ActiveRecord::Migration
  def self.up
    create_table :authentication_tokens do |t|
      t.string :uid
      t.string :token
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :authentication_tokens
  end
end
