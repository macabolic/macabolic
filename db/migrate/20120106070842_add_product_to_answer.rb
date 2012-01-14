class AddProductToAnswer < ActiveRecord::Migration
  def self.up
    add_column :answers, :product_id, :integer    
  end

  def self.down
    remove_column :answers, :product_id
  end
end
