class CreateProductLines < ActiveRecord::Migration
  def self.up
    create_table :product_lines do |t|
      t.string :name, :null => false
      t.integer :vendor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_lines
  end
end
