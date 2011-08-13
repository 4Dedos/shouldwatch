require 'spec_helper'

describe MoviesController do
  context "Autocomplete" do
    it "should search by a keyword" do
      get :search, :query => 'american'
      response.should be_success
    end
  end
end
