class Post < ActiveRecord::Base
  belongs_to :user
  
  # Get my posts together with my friends' posts, and sort in descending order by created_at
  def self.related_to_me(user)
    # Find all my friends + myself first, and put it into a list of users
    @friend_ids = user.my_friends.map(&:friend_id)
    all(:conditions => ["user_id IN (#{@friend_ids}) OR user_id = ?", user],
        :order => "created_at DESC")
  end
  
end
