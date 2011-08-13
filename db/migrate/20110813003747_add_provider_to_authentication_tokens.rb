class AddProviderToAuthenticationTokens < ActiveRecord::Migration
  def self.up
    add_column :authentication_tokens, :provider, :string
  end

  def self.down
    remove_column :authentication_tokens, :provider
  end
end
