require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "should be successful" do
      u = User.new
      u.id = 1
      u.name = "ShouldWatch"
      u.save!
      get 'index'
      response.should be_success
    end
  end

end
