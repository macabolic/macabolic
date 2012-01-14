class AddPermalinkToMyCollection < ActiveRecord::Migration
  def self.up
    add_column :my_collections, :permalink, :string
    add_index :my_collections, :permalink
  end
  def self.down
    remove_column :my_collections, :permalink
  end
end