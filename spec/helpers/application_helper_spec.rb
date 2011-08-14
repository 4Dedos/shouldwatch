require 'spec_helper'

describe ApplicationHelper do
  context "#CurrentUser" do
    before :each do
      @user = User.create(:name => "gianu", :avatar => "http://www.google.com", :email => "none@noneland.com")
      u = User.new
      u.id = 1
      u.name = "ShouldWatch"
      u.save!
    end

    it "should return an anonymous user when the user id is not in the session" do
      session[:user_id] = nil
      user = current_user
      anonymous = User.anonymous

      user.should_not be_nil
      user.name.should == anonymous.name
      user.avatar.should == anonymous.avatar
    end

    it "should return a user with the user_id sotored on session" do
      session[:user_id] = @user.id
      user = current_user

      user.should_not be_nil
      user.should == @user
    end
  end
end

