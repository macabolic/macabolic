class CreateProductTargetAudiences < ActiveRecord::Migration
  def self.up
    create_table :product_target_audiences do |t|
      t.string :name
      t.string :description
      t.integer :sort_order
      t.timestamps
    end
    add_column :products, :product_target_audience_id, :integer
    
    execute <<-SQL
        INSERT INTO product_target_audiences(name, description, sort_order, created_at, updated_at) VALUES ('For Everyone', '', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO product_target_audiences(name, description, sort_order, created_at, updated_at) VALUES ('For Him', '', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    execute <<-SQL
        INSERT INTO product_target_audiences(name, description, sort_order, created_at, updated_at) VALUES ('For Her', '', 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)    
      SQL
    execute <<-SQL
        INSERT INTO product_target_audiences(name, description, sort_order, created_at, updated_at) VALUES ('For Little One', '', 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)    
      SQL
  end

  def self.down
    drop_table :product_target_audiences
    remove_column :products, :product_target_audience_id
  end
end
