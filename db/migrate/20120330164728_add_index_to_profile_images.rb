class AddIndexToProfileImages < ActiveRecord::Migration
  def change
    add_index :profile_images, :user_id, { :name => "profile_images_user_id_index" }
  end
end
