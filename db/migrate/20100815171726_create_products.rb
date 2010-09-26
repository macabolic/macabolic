class CreateProducts < ActiveRecord::Migration
  def self.up
    # types: :primary_key, :string, :text, :integer, :float, :decimal, :datetime, :timestamp, :time, :date, :binary, :boolean
    create_table :products do |t|
      t.string  :name, :null => false
      t.integer :vendor_id
      t.integer :product_line_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
