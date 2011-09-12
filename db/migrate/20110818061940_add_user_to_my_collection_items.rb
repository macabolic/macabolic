class AddUserToMyCollectionItems < ActiveRecord::Migration
  def self.up
    add_column :my_collection_items, :user_id, :integer
  end

  def self.down
    remove_column :my_collection_items, :user_id
  end
end
