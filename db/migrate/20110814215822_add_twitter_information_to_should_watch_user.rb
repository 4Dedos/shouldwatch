class AddTwitterInformationToShouldWatchUser < ActiveRecord::Migration
  def self.up
    user = User.where(:id => 1).first
    token = "354284354-27Woriw4oXcv0vadUa4sZgVKILSGuMoFeOUTnwXa"
    secret = "OgF6gCrrWhJmfWQ0FdktbpidzAno9uBQBMTGBZ0Xe4"

    if user
      user.authentication_tokens.first.update_attributes(:token => token, :secret => secret)
    end
  end

  def self.down
  end
end

