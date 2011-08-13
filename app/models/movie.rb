class Movie < ActiveRecord::Base
  attr_accessor :recommended_by, :recommended_to
end
