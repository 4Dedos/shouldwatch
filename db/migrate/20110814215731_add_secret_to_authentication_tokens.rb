class AddSecretToAuthenticationTokens < ActiveRecord::Migration
  def self.up
    add_column :authentication_tokens, :secret, :string
  end

  def self.down
    remove_column :authentication_tokens, :secret
  end
end
