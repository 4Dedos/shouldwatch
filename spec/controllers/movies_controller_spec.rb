require 'spec_helper'

describe MoviesController do
  context "Autocomplete" do
    it "should search by a keyword" do
      u = User.new
      u.id = 1
      u.name = "ShouldWatch"
      u.avatar = "anonymous.jpg"
      u.save!
      get :search, :term => 'american'
      response.should be_success
    end
  end
end

