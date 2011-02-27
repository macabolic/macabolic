class CreateMyCollectionItems < ActiveRecord::Migration
  def self.up
    create_table :my_collection_items do |t|
      t.integer :my_collection_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :my_collection_items
  end
end
