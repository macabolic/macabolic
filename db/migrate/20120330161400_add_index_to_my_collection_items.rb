class AddIndexToMyCollectionItems < ActiveRecord::Migration
  def change
    add_index :my_collection_items, [:user_id, :my_collection_id], { :name => "my_collection_items_user_id_my_collection_id_index" }
    add_index :my_collection_items, [:user_id, :my_collection_id, :interest_indicator], { :name => "my_collection_items_user_id_my_collection_id_interest_ind_index" }
  end
end