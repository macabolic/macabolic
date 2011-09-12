class AddDescriptionToMyCollections < ActiveRecord::Migration
  def self.up
    add_column :my_collections, :description, :text
  end

  def self.down
    remove_column :my_collections, :description
  end
end
