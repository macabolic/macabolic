class AddIndexToMyCollectionComments < ActiveRecord::Migration
  def change
    add_index :my_collection_comments, :my_collection_id, { :name => "my_collection_comments_my_collection_id_index" }
    add_index :my_collection_comments, [ :my_collection_id, :user_id ], { :name => "my_collection_comments_my_collection_id_user_id_index" }
  end
end
