class ReviewResponse < ActiveRecord::Base
  belongs_to  :review
  belongs_to  :user   # This is the user who responds to the review, not the original author
  
  scope :vote_like, where('response_for = ?', true)
  scope :vote_unlike, where('response_for = ?', false)
end
