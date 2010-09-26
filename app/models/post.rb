class Post < ActiveRecord::Base
  belongs_to :user
  
  # Get my posts together with my friends' posts, and sort in descending order by creatd_at
  # 
  # SELECT * from posts 
  # INNER JOIN users ON
  #   users.id = posts.user_id
  # WHERE posts.user_id = ?
  #
  # SELECT * from posts
  # INNER JOIN users ON
  #   users.id = posts.user_id
  # INNER JOIN my_friends ON
  #   my_friends.friend_id = users.id
  # WHERE my_friends.user_id = ?
  
  def self.related_to_me(current_user)
    # Find all my friends + myself first, and put it into a list of users
    @my_posts = Post.find(:all, 
                          :joins => "INNER JOIN users ON users.id = posts.user_id", 
                          :conditions => ["user_id = ?", current_user.id],
                          :order => "posts.created_at DESC",
                          :limit => 10)
#    @posts_from_my_friends = Post.find_by_sql("SELECT * FROM posts INNER JOIN users ON users.id = posts.user_id INNER JOIN my_friends ON my_friends.friend_id = users.id WHERE my_friends.user_id = ?", current_user.id)                          
#    @posts_from_my_friends = Post.find(:all,
#                          :joins => {"INNER JOIN users ON users.id = posts.user_id", "INNER JOIN my_friends ON my_friends.friend_id = users.id"}
#                          )
  end
  
end
