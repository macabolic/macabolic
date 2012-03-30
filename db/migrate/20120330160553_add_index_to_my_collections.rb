class AddIndexToMyCollections < ActiveRecord::Migration
  def change
    add_index :my_collections, :user_id, { :name => "my_collections_user_id_index" }
  end
end
