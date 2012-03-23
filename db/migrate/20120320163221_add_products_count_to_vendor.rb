class AddProductsCountToVendor < ActiveRecord::Migration
  def self.up
    add_column :vendors, :products_count, :integer, :default => 0  
      
    Vendor.reset_column_information  
    Vendor.find_each do |vendor|  
      Vendor.reset_counters vendor.id, :products
    end
  end

  def self.down
    remove_column :vendors,  :products_count     
  end
end
