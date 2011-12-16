class CreateProfileImages < ActiveRecord::Migration
  def self.up
    create_table :profile_images do |t|
      t.references  :user
      t.string :provider
      t.string :uid
      
      t.timestamps
    end
    
    add_column :users, :profile_image_id, :integer
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_updated_at, :datetime
    
  end

  def self.down
    drop_table :profile_images
    remove_column :users, :profile_image_id
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_updated_at
  end
end
