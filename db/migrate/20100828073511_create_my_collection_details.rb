class CreateMyCollectionDetails < ActiveRecord::Migration
  def self.up
    create_table :my_collection_details do |t|
      t.integer     :my_collection_id
      t.integer     :product_id
      t.integer     :purchased_in
      
      t.timestamps
    end
  end

  def self.down
    drop_table :my_collection_details
  end
end
