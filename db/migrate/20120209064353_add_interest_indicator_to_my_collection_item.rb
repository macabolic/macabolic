class AddInterestIndicatorToMyCollectionItem < ActiveRecord::Migration
  def self.up
    add_column :my_collection_items, :interest_indicator, :integer
  end

  def self.down
    remove_column :my_collection_items, :interest_indicator    
  end
end
