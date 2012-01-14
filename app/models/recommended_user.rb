class RecommendedUser < ActiveRecord::Base
  belongs_to  :recommendations
  belongs_to  :user
end
