class AnswerResponse < ActiveRecord::Base
  belongs_to  :answer
  belongs_to  :user   # This is the user who responds to the answer, not the original author
  
  scope :vote_useful, where('response_for = ?', true)
  scope :vote_not_useful, where('response_for = ?', false)
    
end
