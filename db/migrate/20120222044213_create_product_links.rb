class CreateProductLinks < ActiveRecord::Migration
  def self.up
    create_table :product_links do |t|
      t.references  :product
      t.integer :informer_id    
      t.string :link
      
      t.timestamps
    end
  end

  def self.down
    drop_table :product_links
  end
end
