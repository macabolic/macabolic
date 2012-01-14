class MyCollectionResponse < ActiveRecord::Base
  belongs_to  :my_collection
  belongs_to  :user   # This is the user who responds to the my_collection, not the original owner
  
#  scope :vote_like, where('response_for = ?', true)
#  scope :vote_unlike, where('response_for = ?', false)
  
  searchable do
    integer :my_collection_id
    integer :user_id
  end
  
end
