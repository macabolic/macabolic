class AddIndexToFriendships < ActiveRecord::Migration
  def change
    add_index :friendships, :user_id, { :name => "friendships_user_id_index" }
    add_index :friendships, :friend_id, { :name => "friendships_friend_id_index" }
  end
end
