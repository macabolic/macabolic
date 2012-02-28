class CreatePriceRanges < ActiveRecord::Migration
  def self.up
    create_table :price_ranges do |t|
      t.integer :from_price
      t.integer :to_price
      t.integer :sort_order
      t.timestamps
    end
    add_column :product_links, :price_range_id, :integer
    
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (1, 20, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (20, 40, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (40, 70, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (70, 100, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (100, 200, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (200, 500, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (200, 500, 7, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (500, 2000, 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO PRICE_RANGES("FROM_PRICE", "TO_PRICE", "SORT_ORDER", "CREATED_AT", "UPDATED_AT") VALUES (2000, 1000000, 9, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
  end

  def self.down
    drop_table :price_ranges
    remove_column :product_links, :price_range_id
  end
end
