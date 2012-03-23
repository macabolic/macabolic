class AddMyCollectionItemsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :my_collection_items_count, :integer, :default => 0  
      
    User.reset_column_information  
    User.find_each do |user|  
      User.reset_counters user.id, :my_collection_items
    end
  end

  def self.down
    remove_column :users,  :my_collection_items_count     
  end
end
