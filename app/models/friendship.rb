class Friendship < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :friend,  :class_name => 'User'
  
  searchable do
    integer :user_id
    integer :friend_id
    text    :friend_name do
      friend.full_name.downcase
    end
  end
    
  def full_name
    self.friend.full_name.downcase
  end
  
end
