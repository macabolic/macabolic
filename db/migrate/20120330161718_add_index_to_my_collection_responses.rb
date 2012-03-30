class AddIndexToMyCollectionResponses < ActiveRecord::Migration
  def change
    add_index :my_collection_responses, [:user_id, :my_collection_id], { :name => "my_collection_responses_user_id_my_collection_id_index" }
  end
end
