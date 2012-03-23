class AddMyCollectionItemsCount < ActiveRecord::Migration
  def self.up
    add_column :my_collections, :my_collection_items_count, :integer, :default => 0  
      
    MyCollection.reset_column_information  
    MyCollection.all.each do |my_collection|  
      my_collection.update_attribute :my_collection_items_count, my_collection.my_collection_items.length
    end
  end

  def self.down
    remove_column :my_collections,  :my_collection_items_count 
  end
end
