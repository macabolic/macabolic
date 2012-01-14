class MyCollectionFollower < ActiveRecord::Base
  belongs_to  :my_collection
  belongs_to  :follower,  :class_name => 'User'
  
  searchable do
    integer :my_collection_id
    integer :follower_id
  end
  
end
