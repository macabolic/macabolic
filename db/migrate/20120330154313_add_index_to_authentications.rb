class AddIndexToAuthentications < ActiveRecord::Migration
  def change
    add_index :authentications, :user_id, { :name => "authentications_user_id_index" }
    add_index :authentications, [ :user_id, :provider ], { :name => "authentications_user_id_provider_index" }
  end
end
