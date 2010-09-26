class RemoveProductFromMyCollections < ActiveRecord::Migration
  def self.up
    remove_column :my_collections, :product_id
  end

  def self.down
    add_column :my_collections, :product_id, :integer
  end
end
