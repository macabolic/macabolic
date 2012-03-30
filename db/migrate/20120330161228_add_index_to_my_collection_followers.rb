class AddIndexToMyCollectionFollowers < ActiveRecord::Migration
  def change
    add_index :my_collection_followers, :my_collection_id, { :name => "my_collection_followers_my_collection_id_index" }
  end
end
