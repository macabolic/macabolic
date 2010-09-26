class CreateMyCollections < ActiveRecord::Migration
  def self.up
    create_table :my_collections do |t|
      t.string :name, :null => false
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :my_collections
  end
end
