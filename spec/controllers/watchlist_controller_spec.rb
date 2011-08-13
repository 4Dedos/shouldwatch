require 'spec_helper'

describe WatchlistController do
  before(:each) do
    @user = User.create(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
    login_as(@user)
  end

  it "should add a movie to my watchlist" do
    @user.expects(:add_to_watch_list).with('code')

    post :create, :rt_id => 'code'
  end
end

