class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.integer :vendor_id
      t.integer :product_line_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
