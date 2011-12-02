class AddUserToWishlistItems < ActiveRecord::Migration
  def self.up
    add_column :wishlist_items, :user_id, :integer
  end

  def self.down
    remove_column :wishlist_items, :user_id
  end
end
